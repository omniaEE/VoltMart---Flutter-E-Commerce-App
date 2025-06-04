import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart' as cart_provider;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<cart_provider.CartProvider>(context);
    final orders = cartProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders yet', style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${DateFormat.yMMMd().add_jm().format(order.date)}',
                        ),
                        Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                    children: order.items.map((cartItem) {
                      final product = cartItem.product;
                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/img1.png',
                              width: 50,
                              height: 50,
                            );
                          },
                        ),
                        title: Text(product.name),
                        subtitle: Text(
                          '\$${(product.price * (1 - product.discount / 100)).toStringAsFixed(2)} x ${cartItem.quantity}',
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
