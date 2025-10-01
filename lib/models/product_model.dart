class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int stock;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.stock,
    required this.price,
  });

  // Create a ProductModel from a Firestore document
  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  // Convert a ProductModel to a map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'stock': stock,
      'price': price,
    };
  }
}
