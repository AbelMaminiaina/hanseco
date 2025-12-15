from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from .views import api_root

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', api_root, name='api-root'),
    path('api/auth/', include('hanseco_backend.apps.auth.urls')),
    path('api/oauth/', include('hanseco_backend.apps.oauth.urls')),
    path('api/products/', include('hanseco_backend.apps.products.urls')),
    # Temporarily commented out until URLs are created
    # path('api/cart/', include('hanseco_backend.apps.cart.urls')),
    # path('api/orders/', include('hanseco_backend.apps.orders.urls')),
    # path('api/payments/', include('hanseco_backend.apps.payments.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
