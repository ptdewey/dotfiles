import os
import base64
import requests
from urllib.parse import urlencode, quote
from flask import Flask, request, redirect
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

client_id = os.getenv("SPOTIPY_CLIENT_ID")
client_secret = os.getenv("SPOTIPY_CLIENT_SECRET")
redirect_uri = os.getenv("SPOTIPY_REDIRECT_URI")

state_key = 'spotify_auth_state'

def generate_random_string(length):
    return os.urandom(length).hex()

@app.route('/login')
def login():
    state = generate_random_string(16)
    response = redirect('https://accounts.spotify.com/authorize?' +
                        f'response_type=code&client_id={client_id}&scope=user-read-private%20user-read-email&redirect_uri={redirect_uri}&state={state}')
    response.set_cookie(state_key, state)
    return response

@app.route('/callback')
def callback():
    code = request.args.get('code', '')
    state = request.args.get('state', '')
    stored_state = request.cookies.get(state_key, '')
    
    if state == '' or state != stored_state:
        return redirect('/#' + 'error=state_mismatch')

    auth_header = 'Basic ' + base64.b64encode(f'{client_id}:{client_secret}'.encode('utf-8')).decode('utf-8')
    token_url = 'https://accounts.spotify.com/api/token'

    data = {
        'code': code,
        'redirect_uri': redirect_uri,
        'grant_type': 'authorization_code'
    }

    encoded_data = urlencode({key: quote(value) for key, value in data.items()})

    headers = {
        'Authorization': auth_header,
        'Content-Type': 'application/x-www-form-urlencoded',
    }

    response = requests.post(token_url, data=encoded_data, headers=headers)

    if response.status_code == 200:
        data = response.json()
        access_token = data.get('access_token', '')
        refresh_token = data.get('refresh_token', '')

        # Save the refresh token securely (e.g., in a database or a secure file)
        with open(".refresh_token", "w") as file:
            file.write(refresh_token)

        return redirect('/#' + f'access_token={access_token}&refresh_token={refresh_token}')
    else:
        print(response.status_code, response.text)  # Print details for debugging
        return redirect('/#' + 'error=invalid_token')


@app.route('/')
def home():
    return 'Authorization Successful!'


if __name__ == "__main__":
    app.run(port=8888, debug=True)
