import 'package:flutter/material.dart';
import '../models/product.dart';
import 'product_details_page.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;
  final List<Product> products;

  const CategoryProductsScreen({
    Key? key,
    this.category = '',
    this.products = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter products based on the selected category and convert it to list
    final filteredProducts = products
        .where((product) => product.category == category)
        .toList() 
        .take(8)
        .toList(); 

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: filteredProducts.isEmpty
          ? const Center(child: Text('No products available in this category.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index]; 
                return GestureDetector(
                  onTap: () {
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/img1.png', //if the image link not work
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
