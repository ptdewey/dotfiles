import os
import requests
from dotenv import load_dotenv

load_dotenv()

client_id = os.getenv("SPOTIPY_CLIENT_ID")
client_secret = os.getenv("SPOTIPY_CLIENT_SECRET")
refresh_token = os.getenv("SPOTIPY_REFRESH_TOKEN")

def get_spotify_token(refresh_token):
    token_url = "https://accounts.spotify.com/api/token"
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
    }
    payload = {
        'grant_type': 'refresh_token',
        'refresh_token': refresh_token,
    }

    response = requests.post(
        token_url,
        headers=headers,
        auth=(client_id, client_secret),
        data=payload,
    )

    if response.status_code == 200:
        return response.json().get('access_token')
    else:
        print(f"Failed to refresh Spotify token. Status code: {response.status_code}")
        print(response.text)
        return None

def get_currently_playing_song(token):
    headers = {
        'Authorization': f'Bearer {token}',
    }
    now_playing_url = "https://api.spotify.com/v1/me/player/currently-playing"

    response = requests.get(now_playing_url, headers=headers)

    if response.status_code == 200:
        current_track = response.json()
        if 'item' in current_track:
            track_name = current_track['item']['name']
            artist_name = current_track['item']['artists'][0]['name']
            return f"{artist_name} - {track_name}"
        else:
            return "No song currently playing"
    elif response.status_code == 204:
        return "No active playback"
    else:
        print(f"Failed to retrieve currently playing song. Status code: {response.status_code}")
        print(response.text)
        return "Error fetching currently playing song"

if __name__ == "__main__":
    token = get_spotify_token(refresh_token)

    if token:
        print(get_currently_playing_song(token))
