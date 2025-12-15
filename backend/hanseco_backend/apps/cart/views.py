from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Cart, CartItem


class CartViewSet(viewsets.ViewSet):
    """API pour gérer le panier d'achat"""
    permission_classes = [IsAuthenticated]

    def list(self, request):
        """Récupère le panier de l'utilisateur"""
        cart, created = Cart.objects.get_or_create(user=request.user)
        items = CartItem.objects.filter(cart=cart).select_related('product')

        return Response({
            'items': [
                {
                    'id': item.id,
                    'product': {
                        'id': item.product.id,
                        'name': item.product.name,
                        'price': float(item.product.price),
                        'image': item.product.main_image.url if item.product.main_image else None,
                    },
                    'quantity': item.quantity,
                    'subtotal': float(item.subtotal),
                }
                for item in items
            ],
            'total': float(cart.total),
            'items_count': cart.items_count,
        })

    @action(detail=False, methods=['post'])
    def add_item(self, request):
        """Ajoute un article au panier"""
        product_id = request.data.get('product_id')
        quantity = request.data.get('quantity', 1)

        if not product_id:
            return Response(
                {'error': 'product_id est requis'},
                status=status.HTTP_400_BAD_REQUEST
            )

        cart, created = Cart.objects.get_or_create(user=request.user)

        try:
            from hanseco_backend.apps.products.models import Product
            product = Product.objects.get(id=product_id)
        except Product.DoesNotExist:
            return Response(
                {'error': 'Produit introuvable'},
                status=status.HTTP_404_NOT_FOUND
            )

        cart_item, created = CartItem.objects.get_or_create(
            cart=cart,
            product=product,
            defaults={'quantity': quantity}
        )

        if not created:
            cart_item.quantity += quantity
            cart_item.save()

        return Response({
            'message': 'Article ajouté au panier',
            'item': {
                'id': cart_item.id,
                'quantity': cart_item.quantity,
            }
        })

    @action(detail=True, methods=['put'])
    def update_quantity(self, request, pk=None):
        """Met à jour la quantité d'un article"""
        quantity = request.data.get('quantity')

        if not quantity or quantity < 1:
            return Response(
                {'error': 'Quantité invalide'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            cart_item = CartItem.objects.get(id=pk, cart__user=request.user)
            cart_item.quantity = quantity
            cart_item.save()

            return Response({
                'message': 'Quantité mise à jour',
                'item': {
                    'id': cart_item.id,
                    'quantity': cart_item.quantity,
                    'subtotal': float(cart_item.subtotal),
                }
            })
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Article introuvable'},
                status=status.HTTP_404_NOT_FOUND
            )

    @action(detail=True, methods=['delete'])
    def remove_item(self, request, pk=None):
        """Supprime un article du panier"""
        try:
            cart_item = CartItem.objects.get(id=pk, cart__user=request.user)
            cart_item.delete()

            return Response({
                'message': 'Article supprimé du panier'
            })
        except CartItem.DoesNotExist:
            return Response(
                {'error': 'Article introuvable'},
                status=status.HTTP_404_NOT_FOUND
            )

    @action(detail=False, methods=['delete'])
    def clear(self, request):
        """Vide le panier"""
        try:
            cart = Cart.objects.get(user=request.user)
            cart.items.all().delete()

            return Response({
                'message': 'Panier vidé'
            })
        except Cart.DoesNotExist:
            return Response({
                'message': 'Panier déjà vide'
            })
