from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import GoogleOAuth2View, FacebookOAuth2View, AppleOAuth2View

app_name = 'oauth'

urlpatterns = [
    # OAuth2 Social Login
    path('google/', GoogleOAuth2View.as_view(), name='google-login'),
    path('facebook/', FacebookOAuth2View.as_view(), name='facebook-login'),
    path('apple/', AppleOAuth2View.as_view(), name='apple-login'),

    # JWT Token Management
    path('token/refresh/', TokenRefreshView.as_view(), name='token-refresh'),
]
