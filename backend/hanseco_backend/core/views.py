from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status


@api_view(['GET'])
def api_root(request):
    """
    API Root endpoint - Liste tous les endpoints disponibles
    """
    return Response({
        'message': 'Bienvenue sur l\'API HansEco',
        'version': '1.0.0',
        'endpoints': {
            'authentication': {
                'login': '/api/auth/login/',
                'register': '/api/auth/register/',
                'profile': '/api/auth/me/',
                'logout': '/api/auth/logout/',
            },
            'oauth': {
                'google': '/api/oauth/google/',
                'facebook': '/api/oauth/facebook/',
                'apple': '/api/oauth/apple/',
                'refresh_token': '/api/oauth/token/refresh/',
            },
            'products': {
                'list': '/api/products/',
                'detail': '/api/products/{id}/',
            },
            'admin': '/admin/',
        },
        'documentation': {
            'swagger': '/api/docs/',
            'redoc': '/api/redoc/',
        }
    }, status=status.HTTP_200_OK)
