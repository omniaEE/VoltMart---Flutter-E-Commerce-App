class Category {
  final String name;

  Category({required this.name});

  factory Category.fromJson(String name) {
    print('Parsing Category: $name');
    return Category(name: name);
  }
}
