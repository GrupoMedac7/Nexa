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
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.brand,
    required this.stock,
    required this.price,
    this.imageRef = DEFAULT_PRODUCT_IMAGE_REF,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
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
      imageRef: map['imageRef'] ?? DEFAULT_PRODUCT_IMAGE_REF,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
      isActive: map['isActive'] ?? true,
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
      'imageRef': imageRef,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  // CopyWith para actualizaciones
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? brand,
    int? stock,
    double? price,
    String? imageRef,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      imageRef: imageRef ?? this.imageRef,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, stock: $stock, price: $price)';
  }
}