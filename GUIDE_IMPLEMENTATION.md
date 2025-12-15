# Guide d'Implémentation HansEco

Ce guide vous explique comment compléter l'implémentation de l'application HansEco.

## 📋 État Actuel du Projet

### ✅ Déjà Implémenté

#### Frontend Flutter
- ✅ Structure complète Feature-First + Clean Architecture
- ✅ Configuration Riverpod
- ✅ Navigation avec go_router
- ✅ Thème personnalisé avec couleurs pour chaque provider de paiement
- ✅ Widgets réutilisables (CustomButton, CustomTextField, etc.)
- ✅ Pages d'authentification (Login, Register, Splash)
- ✅ Pages de base pour Products, Cart, Checkout, Profile
- ✅ Configuration Dio pour les appels API
- ✅ Gestion des erreurs
- ✅ Providers Riverpod pour l'authentification

#### Backend Django
- ✅ Configuration Django REST Framework
- ✅ Configuration JWT
- ✅ Configuration CORS
- ✅ Modèles User, Product, Category, ProductImage
- ✅ Serializers pour Auth et Products
- ✅ Endpoints d'authentification (/register, /login, /me)
- ✅ Endpoints produits (/products, /categories)
- ✅ Configuration des paiements dans settings
- ✅ Configuration Celery

## 🚧 À Implémenter

### 1. Backend Django - Modèles Manquants

#### App Cart
Créez le fichier `backend/hanseco_backend/apps/cart/models.py`:

```python
from django.db import models
from django.conf import settings
from hanseco_backend.apps.products.models import Product

class Cart(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('cart', 'product')
```

#### App Orders
Créez le fichier `backend/hanseco_backend/apps/orders/models.py`:

```python
from django.db import models
from django.conf import settings
from hanseco_backend.apps.products.models import Product

class Order(models.Model):
    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('paid', 'Payée'),
        ('processing', 'En traitement'),
        ('shipped', 'Expédiée'),
        ('delivered', 'Livrée'),
        ('cancelled', 'Annulée'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    order_number = models.CharField(max_length=50, unique=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    shipping_address = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
```

#### App Payments
Créez le fichier `backend/hanseco_backend/apps/payments/models.py`:

```python
from django.db import models
from django.conf import settings
from hanseco_backend.apps.orders.models import Order

class Payment(models.Model):
    PROVIDER_CHOICES = [
        ('mvola', 'MVola'),
        ('airtel', 'Airtel Money'),
        ('orange', 'Orange Money'),
        ('paypal', 'PayPal'),
        ('stripe', 'Stripe'),
    ]

    STATUS_CHOICES = [
        ('pending', 'En attente'),
        ('success', 'Réussie'),
        ('failed', 'Échouée'),
        ('cancelled', 'Annulée'),
    ]

    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    provider = models.CharField(max_length=20, choices=PROVIDER_CHOICES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    transaction_id = models.CharField(max_length=255, blank=True)
    payment_data = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
```

### 2. Backend - Services de Paiement

Créez `backend/hanseco_backend/apps/payments/services.py`:

```python
import requests
from django.conf import settings
import stripe
import paypalrestsdk

class MvolaService:
    def __init__(self):
        self.config = settings.PAYMENT_PROVIDERS['mvola']
        self.api_url = self.config['api_url']

    def initiate_payment(self, amount, phone_number, order_id):
        # Implémentation MVola API
        headers = {
            'Authorization': f"Bearer {self.config['api_key']}",
            'Content-Type': 'application/json',
        }
        data = {
            'amount': float(amount),
            'phone': phone_number,
            'reference': order_id,
            'merchant_id': self.config['merchant_id'],
        }
        response = requests.post(f"{self.api_url}/transactions", headers=headers, json=data)
        return response.json()

class AirtelMoneyService:
    def __init__(self):
        self.config = settings.PAYMENT_PROVIDERS['airtel']

    def initiate_payment(self, amount, phone_number, order_id):
        # Implémentation Airtel Money API
        pass

class OrangeMoneyService:
    def __init__(self):
        self.config = settings.PAYMENT_PROVIDERS['orange']

    def initiate_payment(self, amount, phone_number, order_id):
        # Implémentation Orange Money API
        pass

class StripeService:
    def __init__(self):
        stripe.api_key = settings.PAYMENT_PROVIDERS['stripe']['secret_key']

    def create_payment_intent(self, amount, order_id):
        intent = stripe.PaymentIntent.create(
            amount=int(amount * 100),  # Stripe utilise les centimes
            currency='usd',
            metadata={'order_id': order_id},
        )
        return intent

class PayPalService:
    def __init__(self):
        config = settings.PAYMENT_PROVIDERS['paypal']
        paypalrestsdk.configure({
            'mode': config['mode'],
            'client_id': config['client_id'],
            'client_secret': config['client_secret']
        })

    def create_payment(self, amount, order_id):
        payment = paypalrestsdk.Payment({
            'intent': 'sale',
            'payer': {'payment_method': 'paypal'},
            'transactions': [{
                'amount': {
                    'total': str(amount),
                    'currency': 'USD'
                },
                'description': f'Order {order_id}'
            }],
            'redirect_urls': {
                'return_url': 'http://localhost:8000/api/payments/paypal/success',
                'cancel_url': 'http://localhost:8000/api/payments/paypal/cancel'
            }
        })

        if payment.create():
            return payment
        return None
```

### 3. Frontend - Providers Riverpod Manquants

#### Products Provider
Créez `lib/features/products/presentation/providers/products_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

// État des produits
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository repository;

  ProductsNotifier(this.repository) : super(ProductsState());

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await repository.getProducts();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (products) => state = state.copyWith(
        products: products,
        isLoading: false,
      ),
    );
  }
}

// Provider
final productsNotifierProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repository);
});
```

#### Cart Provider
Créez `lib/features/cart/presentation/providers/cart_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class CartState {
  final List<CartItem> items;
  final bool isLoading;

  CartState({
    this.items = const [],
    this.isLoading = false,
  });

  double get total => items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  CartState copyWith({List<CartItem>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem(String productId, String name, double price) {
    final existingIndex = state.items.indexWhere((item) => item.productId == productId);

    if (existingIndex >= 0) {
      final updatedItems = [...state.items];
      updatedItems[existingIndex] = CartItem(
        productId: productId,
        name: name,
        price: price,
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(productId: productId, name: name, price: price, quantity: 1),
        ],
      );
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
  }
}

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
```

### 4. Internationalisation (i18n)

Créez les fichiers de traduction:

`lib/core/i18n/fr.json`:
```json
{
  "login": "Connexion",
  "register": "Inscription",
  "email": "Email",
  "password": "Mot de passe",
  "products": "Produits",
  "cart": "Panier",
  "checkout": "Paiement",
  "profile": "Profil"
}
```

`lib/core/i18n/mg.json`:
```json
{
  "login": "Hiditra",
  "register": "Hisoratra anarana",
  "email": "Email",
  "password": "Teny miafina",
  "products": "Vokatra",
  "cart": "Harona",
  "checkout": "Fandoavam-bola",
  "profile": "Mombamomba"
}
```

## 🔄 Prochaines Étapes

1. **Compléter les modèles Django** pour cart, orders, payments
2. **Créer les migrations** : `python manage.py makemigrations && python manage.py migrate`
3. **Implémenter les services de paiement** avec les APIs réelles
4. **Ajouter les tests** unitaires et d'intégration
5. **Configurer les webhooks** pour les confirmations de paiement
6. **Ajouter la pagination** et le cache
7. **Déployer** sur les stores et serveurs de production

## 📞 Support

Pour toute question, consultez la documentation officielle:
- [Flutter Documentation](https://flutter.dev/docs)
- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [Riverpod Documentation](https://riverpod.dev/)
