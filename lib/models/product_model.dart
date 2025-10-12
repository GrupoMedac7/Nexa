import 'package:nexa/core/constants.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String brand;
  final int stock;
  final double price;
  final String imageRef;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.brand,
    required this.stock,
    required this.price,
    this.imageRef =DEFAULT_PRODUCT_IMAGE_REF,
  });

  // Create a ProductModel from a Firestore document
  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      stock: map['stock'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      imageRef: map['image_ref'],
    );
  }

  // Convert a ProductModel to a map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'brand': brand,
      'stock': stock,
      'price': price,
      'image_ref': imageRef
    };
  }
}