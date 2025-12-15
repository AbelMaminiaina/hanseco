from django.urls import path
from .views import PaymentProvidersView

urlpatterns = [
    path('providers/', PaymentProvidersView.as_view(), name='payment-providers'),
]
