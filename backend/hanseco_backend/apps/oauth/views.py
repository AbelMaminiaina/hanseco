import requests
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.contrib.auth import get_user_model
from django.conf import settings
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

from .serializers import (
    GoogleAuthSerializer,
    FacebookAuthSerializer,
    get_tokens_for_user
)

User = get_user_model()


class GoogleOAuth2View(APIView):
    """
    Google OAuth2 authentication endpoint

    Expected payload:
    {
        "auth_token": "google_id_token"
    }
    """
    permission_classes = [AllowAny]
    serializer_class = GoogleAuthSerializer

    def get(self, request):
        """Documentation for Google OAuth2 endpoint"""
        return Response({
            'endpoint': '/api/oauth/google/',
            'method': 'POST',
            'description': 'Authenticate with Google OAuth2',
            'required_payload': {
                'auth_token': 'Google ID token (string)'
            },
            'example_request': {
                'auth_token': 'eyJhbGciOiJSUzI1NiIsImtpZCI6IjZmNzI1NDEw...'
            },
            'success_response': {
                'access_token': 'JWT access token',
                'refresh_token': 'JWT refresh token',
                'user': {
                    'id': 'user_id',
                    'email': 'user@example.com',
                    'first_name': 'John',
                    'last_name': 'Doe'
                },
                'is_new_user': False
            },
            'how_to_use': [
                '1. User clicks "Sign in with Google" button in your app',
                '2. Google Sign In SDK returns a Google ID token',
                '3. Send POST request to this endpoint with the token',
                '4. Receive JWT tokens to authenticate future requests'
            ],
            'frontend_integration': 'Use the Google Sign In button on http://localhost:3000'
        }, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        auth_token = serializer.validated_data['auth_token']

        try:
            # Try to verify as ID token first (JWT)
            try:
                idinfo = id_token.verify_oauth2_token(
                    auth_token,
                    google_requests.Request(),
                    settings.GOOGLE_OAUTH_CLIENT_ID
                )
                email = idinfo.get('email')
                first_name = idinfo.get('given_name', '')
                last_name = idinfo.get('family_name', '')
            except ValueError:
                # If ID token verification fails, treat it as an access token
                # Use it to call Google People API
                userinfo_url = 'https://www.googleapis.com/oauth2/v2/userinfo'
                headers = {'Authorization': f'Bearer {auth_token}'}
                response = requests.get(userinfo_url, headers=headers)

                if response.status_code != 200:
                    return Response(
                        {'error': 'Invalid Google token'},
                        status=status.HTTP_400_BAD_REQUEST
                    )

                user_data = response.json()
                email = user_data.get('email')
                first_name = user_data.get('given_name', '')
                last_name = user_data.get('family_name', '')

            # Validate email
            if not email:
                return Response(
                    {'error': 'Email not provided by Google'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Get or create user
            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'first_name': first_name,
                    'last_name': last_name,
                    'username': email.split('@')[0],
                }
            )

            # Generate JWT tokens
            tokens = get_tokens_for_user(user)

            return Response({
                'access_token': tokens['access'],
                'refresh_token': tokens['refresh'],
                'user': {
                    'id': user.id,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                },
                'is_new_user': created
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class FacebookOAuth2View(APIView):
    """
    Facebook OAuth2 authentication endpoint

    Expected payload:
    {
        "auth_token": "facebook_access_token"
    }
    """
    permission_classes = [AllowAny]
    serializer_class = FacebookAuthSerializer

    def get(self, request):
        """Documentation for Facebook OAuth2 endpoint"""
        return Response({
            'endpoint': '/api/oauth/facebook/',
            'method': 'POST',
            'description': 'Authenticate with Facebook OAuth2',
            'required_payload': {
                'auth_token': 'Facebook access token (string)'
            },
            'example_request': {
                'auth_token': 'EAABwzLixnjYBO...'
            },
            'success_response': {
                'access_token': 'JWT access token',
                'refresh_token': 'JWT refresh token',
                'user': {
                    'id': 'user_id',
                    'email': 'user@example.com',
                    'first_name': 'John',
                    'last_name': 'Doe'
                },
                'is_new_user': False
            },
            'how_to_use': [
                '1. User clicks "Sign in with Facebook" button in your app',
                '2. Facebook SDK returns a Facebook access token',
                '3. Send POST request to this endpoint with the token',
                '4. Receive JWT tokens to authenticate future requests'
            ],
            'frontend_integration': 'Use the Facebook Sign In button on http://localhost:3000'
        }, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        auth_token = serializer.validated_data['auth_token']

        try:
            # Verify Facebook token
            graph_url = f'https://graph.facebook.com/me?fields=id,name,email,first_name,last_name&access_token={auth_token}'
            response = requests.get(graph_url)

            if response.status_code != 200:
                return Response(
                    {'error': 'Invalid Facebook token'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            user_data = response.json()

            # Get or create user
            email = user_data.get('email')
            if not email:
                return Response(
                    {'error': 'Email not provided by Facebook'},
                    status=status.HTTP_400_BAD_REQUEST
                )

            first_name = user_data.get('first_name', '')
            last_name = user_data.get('last_name', '')

            user, created = User.objects.get_or_create(
                email=email,
                defaults={
                    'first_name': first_name,
                    'last_name': last_name,
                    'username': email.split('@')[0],
                }
            )

            # Generate JWT tokens
            tokens = get_tokens_for_user(user)

            return Response({
                'access_token': tokens['access'],
                'refresh_token': tokens['refresh'],
                'user': {
                    'id': user.id,
                    'email': user.email,
                    'first_name': user.first_name,
                    'last_name': user.last_name,
                },
                'is_new_user': created
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class AppleOAuth2View(APIView):
    """
    Apple Sign In authentication endpoint

    Expected payload:
    {
        "auth_token": "apple_id_token",
        "user_data": {...}  # Optional, only on first sign in
    }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        """Documentation for Apple Sign In endpoint"""
        return Response({
            'endpoint': '/api/oauth/apple/',
            'method': 'POST',
            'description': 'Authenticate with Apple Sign In',
            'status': 'Not yet implemented',
            'required_payload': {
                'auth_token': 'Apple ID token (string)',
                'user_data': 'Optional user data object (only on first sign in)'
            },
            'example_request': {
                'auth_token': 'eyJraWQiOiJXNldjT0tC...',
                'user_data': {
                    'name': {
                        'firstName': 'John',
                        'lastName': 'Doe'
                    },
                    'email': 'user@privaterelay.appleid.com'
                }
            },
            'note': 'This endpoint requires Apple Developer account setup and apple-signin library',
            'frontend_integration': 'Use the Apple Sign In button on http://localhost:3000'
        }, status=status.HTTP_200_OK)

    def post(self, request):
        # TODO: Implement Apple Sign In
        # Requires: apple-signin library and Apple Developer account setup
        return Response(
            {'error': 'Apple Sign In not yet implemented'},
            status=status.HTTP_501_NOT_IMPLEMENTED
        )
