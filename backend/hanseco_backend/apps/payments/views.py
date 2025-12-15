from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated


class PaymentProvidersView(APIView):
    """Liste des providers de paiement disponibles"""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        providers = [
            {
                'id': 'mvola',
                'name': 'MVola',
                'available': True,
            },
            {
                'id': 'airtel',
                'name': 'Airtel Money',
                'available': True,
            },
            {
                'id': 'orange',
                'name': 'Orange Money',
                'available': True,
            },
            {
                'id': 'paypal',
                'name': 'PayPal',
                'available': True,
            },
            {
                'id': 'stripe',
                'name': 'Stripe',
                'available': True,
            },
        ]

        return Response({'providers': providers})
