import 'package:flutter/material.dart';
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1}) {
    // Validate quantity on creation
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
  }

  /// Converts the CartItem to a JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {'productId': product.id, 'quantity': quantity};
  }

  /// Creates a CartItem from a JSON map, given a Product instance.
  factory CartItem.fromJson(Map<String, dynamic> json, Product product) {
    final quantity = json['quantity'] as int? ?? 1;
    if (quantity <= 0) {
      throw ArgumentError('Invalid quantity in JSON: $quantity');
    }
    return CartItem(product: product, quantity: quantity);
  }

  /// Updates the quantity with validation.
  void updateQuantity(int newQuantity) {
    if (newQuantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    quantity = newQuantity;
  }

  /// Checks equality based on product ID and quantity.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product.id == other.product.id &&
          quantity == other.quantity;

  @override
  int get hashCode => Object.hash(product.id, quantity);

  @override
  String toString() =>
      'CartItem(productId: ${product.id}, quantity: $quantity)';
}
