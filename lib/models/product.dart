class Product {
  final int id;
  final String name;
  final String category;
  final String description;
  final double price; // Change to double
  final int discount; // Keep as int, but ensure it's parsed correctly
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.discount,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: (json['price'] is int)
          ? json['price'].toDouble()
          : double.parse(json['price'].toString()), // Ensure price is double
      discount: json['discount'], // Assuming discount is always an int
      image: json['image'],
    );
  }
}
