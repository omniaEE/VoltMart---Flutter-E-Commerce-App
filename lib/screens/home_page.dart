import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../utils/ThemeToggleSwitch.dart';
import '../constants/constants.dart';
import '../models/user.dart';
import '../providers/theme_provider.dart';
import '../models/product.dart';
import '../models/category.dart';
import './category_products_page.dart';
import './product_details_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Guest';
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchData();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.loggedUserKey);
    if (userJson != null) {
      try {
        final user = User.fromJson(jsonDecode(userJson));
        setState(() {
          _userName = user.firstName.isNotEmpty ? user.firstName : 'Guest';
        });
      } catch (e) {
        print('Error loading user: $e');
      }
    }
  }

  Future<void> _fetchData() async {
    try {
      final productsResponse = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/v1/all/products'),
        headers: {'Accept': 'application/json'},
      );
      final categoriesResponse = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/v1/all/categories'),
        headers: {'Accept': 'application/json'},
      );

      print('Products Status: ${productsResponse.statusCode}');
      print('Categories Status: ${categoriesResponse.statusCode}');

      if (productsResponse.statusCode == 200 &&
          categoriesResponse.statusCode == 200) {
        final productsData = jsonDecode(productsResponse.body);
        final categoriesData = jsonDecode(categoriesResponse.body);

        print('Products Response: $productsData');
        print('Categories Response: $categoriesData');

        setState(() {
          try {
            List<dynamic> productsList = productsData is List
                ? productsData
                : [];
            _products =
                productsList
                    .map((json) {
                      try {
                        return Product.fromJson(json as Map<String, dynamic>);
                      } catch (e) {
                        print('Error parsing Product: $e, JSON: $json');
                        return null;
                      }
                    })
                    .where((product) => product != null)
                    .cast<Product>()
                    .toList()
                  ..sort((a, b) => b.id.compareTo(a.id));
          } catch (e) {
            print('Products parsing error (ignored): $e');
            _products = [];
          }

          _categories = (categoriesData as List? ?? [])
              .map((name) {
                try {
                  return Category.fromJson(name as String);
                } catch (e) {
                  print('Error parsing Category: $name, Error: $e');
                  return null;
                }
              })
              .where((category) => category != null)
              .cast<Category>()
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load data. Status: ${productsResponse.statusCode}, ${categoriesResponse.statusCode}';
        });
      }
    } catch (e) {
      print('Fetch Data Error (ignored): $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading data, please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('VoltMart'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.profileRoute);
            },
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.yellow[700] : Colors.blueGrey,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ThemeToggleSwitch(),
                ),
              );
            },
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products: _products),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : RefreshIndicator(
              onRefresh: _fetchData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Message
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Welcome, $_userName!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // top product slider
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final images = [
                            'https://via.placeholder.com/800x200?text=Promo+1',
                            'https://via.placeholder.com/800x200?text=Promo+2',
                            'https://via.placeholder.com/800x200?text=Promo+3',
                          ];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/img1.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Featured Products',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    _products.isEmpty
                        ? const Center(child: Text('No products available'))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: _products.length.clamp(0, 6),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to ProductDetailsScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                            product: product,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/img1.png',
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    // product categories
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Categories',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ActionChip(
                              label: Text(category.name),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryProductsScreen(
                                          category: category.name,
                                          products: _products,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // new arrivals
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'New Arrivals',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    _products.isEmpty
                        ? const Center(child: Text('No new arrivals available'))
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: _products.length.clamp(0, 6),
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return GestureDetector(
                                onTap: () {
                                  // Navigate to ProductDetailsScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                            product: product,
                                          ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Image.asset(
                                                  'assets/images/img1.png',
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<Product> products;

  ProductSearchDelegate({required this.products});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(
            product.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(product.name),
          onTap: () {
            query = product.name;
            showResults(context);
          },
        );
      },
    );
  }
}
