import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/cart_item.dart';
import '../../../products/domain/entities/product.dart';

// Cart State
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Cart Notifier with Hive persistence
class CartNotifier extends StateNotifier<CartState> {
  static const String _cartBoxName = 'cart_box';
  static const String _cartKey = 'cart_items';

  Box? _cartBox;

  CartNotifier() : super(CartState()) {
    _initializeCart();
  }

  // Initialize cart from local storage
  Future<void> _initializeCart() async {
    state = state.copyWith(isLoading: true);

    try {
      _cartBox = await Hive.openBox(_cartBoxName);
      await _loadCartFromStorage();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load cart: ${e.toString()}',
      );
    }
  }

  // Load cart from Hive storage
  Future<void> _loadCartFromStorage() async {
    final cartData = _cartBox?.get(_cartKey) as List<dynamic>?;

    if (cartData != null) {
      final items = cartData.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return CartItem(
          productId: map['productId'] as String,
          productName: map['productName'] as String,
          price: (map['price'] as num).toDouble(),
          quantity: map['quantity'] as int,
          imageUrl: map['imageUrl'] as String?,
        );
      }).toList();

      state = state.copyWith(items: items);
    }
  }

  // Save cart to Hive storage
  Future<void> _saveCartToStorage() async {
    final cartData = state.items.map((item) => {
      'productId': item.productId,
      'productName': item.productName,
      'price': item.price,
      'quantity': item.quantity,
      'imageUrl': item.imageUrl,
    }).toList();

    await _cartBox?.put(_cartKey, cartData);
  }

  // Add item to cart
  Future<void> addItem(Product product, {int quantity = 1}) async {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == product.id,
    );

    List<CartItem> updatedItems;

    if (existingIndex >= 0) {
      // Item already exists, update quantity
      updatedItems = [...state.items];
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // Add new item
      updatedItems = [
        ...state.items,
        CartItem(
          productId: product.id,
          productName: product.name,
          price: product.price,
          quantity: quantity,
          imageUrl: product.images.isNotEmpty ? product.images.first : null,
        ),
      ];
    }

    state = state.copyWith(items: updatedItems);
    await _saveCartToStorage();
  }

  // Remove item from cart
  Future<void> removeItem(String productId) async {
    final updatedItems = state.items
        .where((item) => item.productId != productId)
        .toList();

    state = state.copyWith(items: updatedItems);
    await _saveCartToStorage();
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    await _saveCartToStorage();
  }

  // Increment item quantity
  Future<void> incrementQuantity(String productId) async {
    final item = state.items.firstWhere(
      (item) => item.productId == productId,
    );
    await updateQuantity(productId, item.quantity + 1);
  }

  // Decrement item quantity
  Future<void> decrementQuantity(String productId) async {
    final item = state.items.firstWhere(
      (item) => item.productId == productId,
    );
    await updateQuantity(productId, item.quantity - 1);
  }

  // Clear cart
  Future<void> clearCart() async {
    state = state.copyWith(items: []);
    await _saveCartToStorage();
  }

  // Get item quantity by product ID
  int getItemQuantity(String productId) {
    final item = state.items.cast<CartItem?>().firstWhere(
      (item) => item?.productId == productId,
      orElse: () => null,
    );
    return item?.quantity ?? 0;
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return state.items.any((item) => item.productId == productId);
  }

  @override
  void dispose() {
    _cartBox?.close();
    super.dispose();
  }
}

// Cart Provider
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Helper providers
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartNotifierProvider);
  return cartState.itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartNotifierProvider);
  return cartState.total;
});

final cartIsEmptyProvider = Provider<bool>((ref) {
  final cartState = ref.watch(cartNotifierProvider);
  return cartState.isEmpty;
});
