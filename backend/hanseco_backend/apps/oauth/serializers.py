from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken

User = get_user_model()


class SocialAuthSerializer(serializers.Serializer):
    """Serializer for social authentication"""
    provider = serializers.CharField(required=True)
    access_token = serializers.CharField(required=True)
    id_token = serializers.CharField(required=False, allow_blank=True)


class TokenResponseSerializer(serializers.Serializer):
    """Serializer for token response"""
    access_token = serializers.CharField()
    refresh_token = serializers.CharField()
    user = serializers.SerializerMethodField()

    def get_user(self, obj):
        user = obj.get('user')
        if user:
            return {
                'id': user.id,
                'email': user.email,
                'first_name': user.first_name,
                'last_name': user.last_name,
            }
        return None


class GoogleAuthSerializer(serializers.Serializer):
    """Google OAuth2 authentication"""
    auth_token = serializers.CharField()

    def validate_auth_token(self, auth_token):
        # This will be validated in the view
        return auth_token


class FacebookAuthSerializer(serializers.Serializer):
    """Facebook OAuth2 authentication"""
    auth_token = serializers.CharField()

    def validate_auth_token(self, auth_token):
        # This will be validated in the view
        return auth_token


def get_tokens_for_user(user):
    """Generate JWT tokens for user"""
    refresh = RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }
