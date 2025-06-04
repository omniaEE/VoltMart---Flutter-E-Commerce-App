import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;

  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold<double>(
    0.0,
    (sum, item) =>
        sum +
        item.quantity *
            (item.product.price * (1 - item.product.discount / 100)),
  );

  void addToCart(Product product) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (existingItemIndex >= 0) {
      _items.removeAt(existingItemIndex);
      notifyListeners();
    }
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity < 1) {
      removeFromCart(productId);
      return;
    }
    final existingItemIndex = _items.indexWhere(
      (item) => item.product.id == productId,
    );
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  void placeOrder() {
    if (_items.isNotEmpty) {
      _orders.add(
        Order(
          id: DateTime.now().millisecondsSinceEpoch
              .toString(), // Simple unique ID
          items: List.from(_items), // Copy current cart items
          totalPrice: totalPrice,
          date: DateTime.now(),
        ),
      );
      _items.clear(); // Clear the cart
      notifyListeners();
    }
  }
}
