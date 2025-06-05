
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold<int>(0, (sum, item) => sum + item.quantity);

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
}

class Order {
  final String id;
  final List<CartItem> items; 
  final double totalPrice; 
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.date,
  });
}
