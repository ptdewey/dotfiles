---
name: atproto-oauth-go
description: AT Protocol OAuth implementation in Go using the bluesky-social/indigo SDK. Use when implementing authentication flows for AT Protocol applications, handling OAuth login/callback/logout, managing authenticated sessions, or working with DPOP tokens and PKCE flows. Also covers Go 1.23+ Cross-Origin Protection for CSRF prevention without tokens.
---

# AT Protocol OAuth in Go

Guide for implementing OAuth authentication with AT Protocol (ATProto) in Go applications using the `github.com/bluesky-social/indigo` SDK.

## Key Concepts

**AT Protocol OAuth** uses industry-standard OAuth 2.0 with PKCE (Proof Key for Code Exchange) and DPOP (Demonstrating Proof of Possession) for enhanced security.

**Personal Data Server (PDS)**: Each user has their own PDS that stores their data. Your app authenticates to access their PDS via OAuth.

**DID (Decentralized Identifier)**: Users are identified by DIDs (e.g., `did:plc:xyz123`), not by your app's database IDs.

**Handles**: User-friendly identifiers (e.g., `alice.bsky.social`) that resolve to DIDs.

## Core Components

### 1. OAuth Manager

The OAuth manager handles the complete OAuth flow using indigo's built-in support:

```go
import (
    "github.com/bluesky-social/indigo/atproto/identity"
    "github.com/bluesky-social/indigo/atproto/oauth"
)

type OAuthManager struct {
    oauthManager *oauth.Manager
    directory    identity.Directory
    sessions     SessionStore
}

func NewOAuthManager(clientID, redirectURI string, sessions SessionStore) (*OAuthManager, error) {
    // Use DefaultDirectory for production (handles did:plc and did:web resolution)
    directory := identity.DefaultDirectory()
    
    // Create OAuth manager with client metadata
    oauthManager, err := oauth.NewManager(oauth.ManagerConfig{
        Client: oauth.ClientMetadata{
            ClientID:     clientID,
            RedirectURIs: []string{redirectURI},
            // Scopes requested from user's PDS
            Scopes: []string{
                "atproto",
                "refresh",
            },
        },
        Directory: directory,
        // Store for PKCE verifiers and OAuth state
        StateStore: oauth.NewMemoryStateStore(),
    })
    if err != nil {
        return nil, err
    }
    
    return &OAuthManager{
        oauthManager: oauthManager,
        directory:    directory,
        sessions:     sessions,
    }, nil
}
```

### 2. OAuth Flow Handlers

#### Login Handler (Initiate OAuth)

```go
func (m *OAuthManager) HandleLogin(w http.ResponseWriter, r *http.Request) {
    // Get handle from form submission
    handle := r.FormValue("handle")
    if handle == "" {
        http.Error(w, "Handle required", http.StatusBadRequest)
        return
    }
    
    // Resolve handle to DID
    identity, err := m.directory.Lookup(r.Context(), atproto.HandleOrDID(handle))
    if err != nil {
        http.Error(w, "Could not resolve handle", http.StatusBadRequest)
        return
    }
    
    // Start OAuth flow
    authURL, err := m.oauthManager.Authorize(r.Context(), identity.DID, nil)
    if err != nil {
        http.Error(w, "Failed to start OAuth flow", http.StatusInternalServerError)
        return
    }
    
    // Redirect to user's PDS for authorization
    http.Redirect(w, r, authURL, http.StatusFound)
}
```

#### OAuth Callback Handler

```go
func (m *OAuthManager) HandleCallback(w http.ResponseWriter, r *http.Request) {
    // Exchange authorization code for tokens (indigo handles PKCE and DPOP)
    token, err := m.oauthManager.HandleCallback(r.Context(), r.URL)
    if err != nil {
        http.Error(w, "OAuth callback failed", http.StatusBadRequest)
        return
    }
    
    // Create session for authenticated user
    sessionID := generateSecureRandomString(32) // Use crypto/rand
    session := Session{
        DID:          token.Sub, // Subject (user's DID)
        AccessToken:  token.AccessToken,
        RefreshToken: token.RefreshToken,
        ExpiresAt:    time.Now().Add(token.ExpiresIn),
    }
    
    if err := m.sessions.Save(r.Context(), sessionID, session); err != nil {
        http.Error(w, "Failed to save session", http.StatusInternalServerError)
        return
    }
    
    // Set secure session cookie
    http.SetCookie(w, &http.Cookie{
        Name:     "session_id",
        Value:    sessionID,
        Path:     "/",
        HttpOnly: true,
        Secure:   true, // Require HTTPS in production
        SameSite: http.SameSiteLaxMode,
        MaxAge:   86400 * 7, // 7 days
    })
    
    // Set DID cookie (used by auth middleware)
    http.SetCookie(w, &http.Cookie{
        Name:     "did",
        Value:    token.Sub,
        Path:     "/",
        HttpOnly: true,
        Secure:   true,
        SameSite: http.SameSiteLaxMode,
        MaxAge:   86400 * 7,
    })
    
    http.Redirect(w, r, "/", http.StatusFound)
}
```

#### Logout Handler

```go
func (m *OAuthManager) HandleLogout(w http.ResponseWriter, r *http.Request) {
    // Get session ID from cookie
    cookie, err := r.Cookie("session_id")
    if err == nil {
        // Delete session from store
        m.sessions.Delete(r.Context(), cookie.Value)
    }
    
    // Clear cookies
    http.SetCookie(w, &http.Cookie{
        Name:     "session_id",
        Path:     "/",
        MaxAge:   -1, // Delete cookie
        HttpOnly: true,
        Secure:   true,
        SameSite: http.SameSiteLaxMode,
    })
    http.SetCookie(w, &http.Cookie{
        Name:     "did",
        Path:     "/",
        MaxAge:   -1,
        HttpOnly: true,
        Secure:   true,
        SameSite: http.SameSiteLaxMode,
    })
    
    http.Redirect(w, r, "/", http.StatusFound)
}
```

### 3. Auth Middleware

Middleware to extract auth info and add to request context:

```go
type contextKey string

const (
    ContextKeyDID       contextKey = "did"
    ContextKeySession   contextKey = "session_id"
)

func (m *OAuthManager) AuthMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Extract DID from cookie
        didCookie, err := r.Cookie("did")
        if err == nil {
            ctx := context.WithValue(r.Context(), ContextKeyDID, didCookie.Value)
            r = r.WithContext(ctx)
        }
        
        // Extract session ID from cookie
        sessionCookie, err := r.Cookie("session_id")
        if err == nil {
            ctx := context.WithValue(r.Context(), ContextKeySession, sessionCookie.Value)
            r = r.WithContext(ctx)
        }
        
        next.ServeHTTP(w, r)
    })
}

// Helper to check if request is authenticated
func IsAuthenticated(r *http.Request) bool {
    did, ok1 := r.Context().Value(ContextKeyDID).(string)
    sessionID, ok2 := r.Context().Value(ContextKeySession).(string)
    return ok1 && ok2 && did != "" && sessionID != ""
}

// Helper to get authenticated user's DID
func GetUserDID(r *http.Request) (string, bool) {
    did, ok := r.Context().Value(ContextKeyDID).(string)
    return did, ok && did != ""
}
```

### 4. Making Authenticated Requests

Use the OAuth token to make authenticated XRPC calls to the user's PDS:

```go
import (
    "github.com/bluesky-social/indigo/xrpc"
)

// Create authenticated XRPC client
func (m *OAuthManager) GetAuthenticatedClient(ctx context.Context, sessionID string) (*xrpc.Client, error) {
    // Retrieve session
    session, err := m.sessions.Get(ctx, sessionID)
    if err != nil {
        return nil, err
    }
    
    // Check if token needs refresh
    if time.Now().After(session.ExpiresAt.Add(-5 * time.Minute)) {
        // Refresh token
        newToken, err := m.oauthManager.Refresh(ctx, session.RefreshToken)
        if err != nil {
            return nil, err
        }
        
        // Update session
        session.AccessToken = newToken.AccessToken
        session.RefreshToken = newToken.RefreshToken
        session.ExpiresAt = time.Now().Add(newToken.ExpiresIn)
        m.sessions.Save(ctx, sessionID, session)
    }
    
    // Resolve user's PDS endpoint
    identity, err := m.directory.Lookup(ctx, atproto.DID(session.DID))
    if err != nil {
        return nil, err
    }
    
    // Create authenticated client
    client := &xrpc.Client{
        Host: identity.PDSEndpoint(),
        Auth: &xrpc.AuthInfo{
            AccessJwt:  session.AccessToken,
            RefreshJwt: session.RefreshToken,
            Handle:     identity.Handle.String(),
            Did:        session.DID,
        },
    }
    
    return client, nil
}
```

## Go 1.23+ CSRF Protection (No Tokens Required)

Go 1.23 introduced `http.CrossOriginProtection` which provides CSRF protection **without tokens** using modern browser headers.

### How It Works

Instead of traditional CSRF tokens, Go 1.23 uses:

1. **`Sec-Fetch-Site` header** - Modern browsers (since 2023) automatically send this
2. **`Origin` header** - Fallback method comparing Origin with Host

**Safe methods** (GET, HEAD, OPTIONS) are always allowed.  
**Unsafe methods** (POST, PUT, DELETE) are rejected if they appear to be cross-origin.

### Implementation

```go
import "net/http"

func SetupRouter() http.Handler {
    mux := http.NewServeMux()
    
    // Create CSRF protection (zero value is valid)
    cop := http.NewCrossOriginProtection()
    
    // GET routes don't need protection (safe methods)
    mux.HandleFunc("GET /login", handleLogin)
    mux.HandleFunc("GET /api/data", handleAPIData)
    
    // POST/PUT/DELETE routes need protection
    mux.Handle("POST /auth/login", cop.Handler(http.HandlerFunc(handleLoginSubmit)))
    mux.Handle("POST /logout", cop.Handler(http.HandlerFunc(handleLogout)))
    mux.Handle("POST /brews", cop.Handler(http.HandlerFunc(handleBrewCreate)))
    mux.Handle("PUT /brews/{id}", cop.Handler(http.HandlerFunc(handleBrewUpdate)))
    mux.Handle("DELETE /brews/{id}", cop.Handler(http.HandlerFunc(handleBrewDelete)))
    
    return mux
}
```

### No Token Needed in Forms

Frontend forms work without CSRF tokens:

```html
<!-- Traditional form submission - no token field needed -->
<form method="POST" action="/auth/login">
  <input type="text" name="handle" required />
  <button type="submit">Log In</button>
</form>
```

```javascript
// Fetch API - no token header needed
async function createBrew(data) {
  const response = await fetch('/brews', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
    // Browser automatically sends Sec-Fetch-Site: same-origin
  });
  return response.json();
}
```

### Advanced Configuration (Optional)

```go
// Add trusted origins (if you have multiple domains)
cop := http.NewCrossOriginProtection()
cop.AddTrustedOrigin("https://app.example.com")
cop.AddTrustedOrigin("https://admin.example.com")

// Custom deny handler
cop.SetDenyHandler(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
    log.Warn().
        Str("origin", r.Header.Get("Origin")).
        Str("host", r.Host).
        Msg("Cross-origin request blocked")
    http.Error(w, "Forbidden", http.StatusForbidden)
}))

// Use pattern bypass (use sparingly, weakens protection)
cop.AddInsecureBypassPattern("/webhooks/*") // Allow cross-origin webhooks
```

### Important Notes

- **No token generation** - `CrossOriginProtection` doesn't expose or use tokens
- **No context keys** - There's no `http.CSRFTokenContextKey` or similar API
- **Browser requirement** - Relies on modern browser headers (2023+)
- **No impact on API design** - Frontend code doesn't change, just wrap handlers

### When NOT to Use

- **Public APIs** - Use API keys/tokens instead for cross-origin API access
- **Webhooks** - External services can't send proper headers, use signatures instead
- **Mobile apps** - Native apps don't send browser headers, use app-specific auth

## Client Metadata Endpoint

OAuth clients must serve metadata at `/.well-known/oauth-client-metadata`:

```go
func HandleClientMetadata(w http.ResponseWriter, r *http.Request) {
    metadata := map[string]interface{}{
        "client_id":     os.Getenv("OAUTH_CLIENT_ID"),
        "client_name":   "Your App Name",
        "redirect_uris": []string{
            os.Getenv("OAUTH_REDIRECT_URI"),
        },
        "scope": "atproto refresh",
        "grant_types": []string{
            "authorization_code",
            "refresh_token",
        },
        "response_types": []string{"code"},
        "token_endpoint_auth_method": "none", // Public client
        "application_type": "web",
        "dpop_bound_access_tokens": true,
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(metadata)
}

// Mount at both paths
mux.HandleFunc("GET /client-metadata.json", HandleClientMetadata)
mux.HandleFunc("GET /.well-known/oauth-client-metadata", HandleClientMetadata)
```

## Session Storage

Example using BoltDB:

```go
type Session struct {
    DID          string
    AccessToken  string
    RefreshToken string
    ExpiresAt    time.Time
}

type BoltSessionStore struct {
    db *bolt.DB
}

func (s *BoltSessionStore) Save(ctx context.Context, sessionID string, session Session) error {
    data, err := json.Marshal(session)
    if err != nil {
        return err
    }
    
    return s.db.Update(func(tx *bolt.Tx) error {
        bucket := tx.Bucket([]byte("sessions"))
        return bucket.Put([]byte(sessionID), data)
    })
}

func (s *BoltSessionStore) Get(ctx context.Context, sessionID string) (Session, error) {
    var session Session
    
    err := s.db.View(func(tx *bolt.Tx) error {
        bucket := tx.Bucket([]byte("sessions"))
        data := bucket.Get([]byte(sessionID))
        if data == nil {
            return errors.New("session not found")
        }
        return json.Unmarshal(data, &session)
    })
    
    return session, err
}

func (s *BoltSessionStore) Delete(ctx context.Context, sessionID string) error {
    return s.db.Update(func(tx *bolt.Tx) error {
        bucket := tx.Bucket([]byte("sessions"))
        return bucket.Delete([]byte(sessionID))
    })
}
```

## Environment Variables

```bash
# OAuth Configuration
OAUTH_CLIENT_ID=https://your-app.com/client-metadata.json
OAUTH_REDIRECT_URI=https://your-app.com/oauth/callback

# For development (allows HTTP cookies)
# For production, use HTTPS and remove this
SERVER_PUBLIC_URL=http://localhost:3000
```

## Common Patterns

### Protected Route Example

```go
func HandleProtectedAPI(w http.ResponseWriter, r *http.Request) {
    // Check authentication
    if !IsAuthenticated(r) {
        http.Error(w, "Unauthorized", http.StatusUnauthorized)
        return
    }
    
    // Get user's DID
    did, _ := GetUserDID(r)
    
    // Get session ID for authenticated client
    sessionID, _ := r.Context().Value(ContextKeySession).(string)
    
    // Make authenticated XRPC call
    client, err := oauthManager.GetAuthenticatedClient(r.Context(), sessionID)
    if err != nil {
        http.Error(w, "Failed to get client", http.StatusInternalServerError)
        return
    }
    
    // Use client to fetch user's data from their PDS
    // ... XRPC calls here ...
}
```

### Handle Resolution for Login Autocomplete

```go
func HandleResolveHandle(w http.ResponseWriter, r *http.Request) {
    handle := r.URL.Query().Get("handle")
    if handle == "" {
        http.Error(w, "Handle required", http.StatusBadRequest)
        return
    }
    
    // Resolve handle to identity
    identity, err := directory.Lookup(r.Context(), atproto.HandleOrDID(handle))
    if err != nil {
        http.Error(w, "Could not resolve handle", http.StatusNotFound)
        return
    }
    
    // Return basic profile info for autocomplete
    response := map[string]string{
        "did":    identity.DID.String(),
        "handle": identity.Handle.String(),
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(response)
}
```

## Troubleshooting

**"Invalid OAuth state"**: PKCE verifier expired or mismatched. Ensure StateStore is shared across requests.

**"Token expired"**: Implement token refresh before making requests (check ExpiresAt).

**"Could not resolve handle"**: Handle doesn't exist or PDS is unreachable. Use Directory.Lookup() to check.

**"Cross-origin request blocked"**: POST/PUT/DELETE from different origin. Either same-origin or add to trusted origins.

**Session not persisting**: Check cookie security settings (Secure flag requires HTTPS, use HTTP in local dev).

## Dependencies

```go
import (
    "github.com/bluesky-social/indigo/atproto/identity"
    "github.com/bluesky-social/indigo/atproto/oauth"
    "github.com/bluesky-social/indigo/xrpc"
)
```

```bash
go get github.com/bluesky-social/indigo
```
