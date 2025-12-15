from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Order


class OrderViewSet(viewsets.ReadOnlyModelViewSet):
    """API pour consulter les commandes"""
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')

    def list(self, request):
        """Liste toutes les commandes de l'utilisateur"""
        orders = self.get_queryset()

        return Response({
            'orders': [
                {
                    'id': order.id,
                    'status': order.status,
                    'payment_status': order.payment_status,
                    'total': float(order.total),
                    'created_at': order.created_at,
                    'items_count': order.items.count(),
                }
                for order in orders
            ]
        })

    def retrieve(self, request, pk=None):
        """Détails d'une commande"""
        try:
            order = self.get_queryset().get(id=pk)

            return Response({
                'id': order.id,
                'status': order.status,
                'payment_status': order.payment_status,
                'total': float(order.total),
                'shipping_address': order.shipping_address,
                'shipping_city': order.shipping_city,
                'shipping_postal_code': order.shipping_postal_code,
                'shipping_phone': order.shipping_phone,
                'payment_method': order.payment_method,
                'created_at': order.created_at,
                'items': [
                    {
                        'product': {
                            'id': item.product.id,
                            'name': item.product.name,
                        },
                        'quantity': item.quantity,
                        'price': float(item.price),
                        'subtotal': float(item.subtotal),
                    }
                    for item in order.items.all()
                ]
            })
        except Order.DoesNotExist:
            return Response(
                {'error': 'Commande introuvable'},
                status=404
            )
