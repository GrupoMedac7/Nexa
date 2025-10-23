import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_filter.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Obtener productos con filtros avanzados
  Future<List<Product>> getProductsWithFilters(ProductFilter filter) async {
    try {
      Query query = _firestore.collection(_collection);

      // Aplicar filtro de categoría
      if (filter.category != null && filter.category!.isNotEmpty) {
        query = query.where('category', isEqualTo: filter.category);
      }

      // Aplicar filtro de estado activo
      if (filter.isActive != null) {
        query = query.where('isActive', isEqualTo: filter.isActive);
      }

      // Aplicar filtros de stock
      if (filter.minStock != null) {
        query = query.where('stock', isGreaterThanOrEqualTo: filter.minStock);
      }
      
      if (filter.maxStock != null) {
        query = query.where('stock', isLessThanOrEqualTo: filter.maxStock);
      }

      // Aplicar filtros de precio
      if (filter.minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: filter.minPrice);
      }
      
      if (filter.maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: filter.maxPrice);
      }

      // Aplicar filtro de rango de fechas
      if (filter.dateRange != null) {
        query = query
            .where('createdAt', isGreaterThanOrEqualTo: filter.dateRange!.start)
            .where('createdAt', isLessThanOrEqualTo: filter.dateRange!.end);
      }

      // Ordenar por stock descendente para ver productos con más stock primero
      query = query.orderBy('stock', descending: true);

      final QuerySnapshot snapshot = await query.get();
      List<Product> products = snapshot.docs
          .map((doc) => Product.fromFirestore(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();

      // Aplicar filtro de búsqueda por nombre (no se puede hacer en Firestore directamente)
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        products = products.where((product) {
          return product.name
              .toLowerCase()
              .contains(filter.searchQuery!.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(filter.searchQuery!.toLowerCase());
        }).toList();
      }

      return products;
    } catch (e) {
      print('Error al obtener productos con filtros: $e');
      return [];
    }
  }

  // Obtener estadísticas de stock
  Future<Map<String, dynamic>> getStockStatistics() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'totalProducts': 0,
          'totalStock': 0,
          'averageStock': 0.0,
          'lowStockCount': 0,
          'outOfStockCount': 0,
          'highStockCount': 0,
        };
      }

      List<int> stockValues = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['stock'] as int? ?? 0)
          .toList();

      int totalStock = stockValues.fold(0, (sum, stock) => sum + stock);
      int lowStockCount = stockValues.where((stock) => stock > 0 && stock <= 10).length;
      int outOfStockCount = stockValues.where((stock) => stock == 0).length;
      int highStockCount = stockValues.where((stock) => stock > 100).length;

      return {
        'totalProducts': stockValues.length,
        'totalStock': totalStock,
        'averageStock': totalStock / stockValues.length,
        'lowStockCount': lowStockCount,
        'outOfStockCount': outOfStockCount,
        'highStockCount': highStockCount,
        'minStock': stockValues.reduce((a, b) => a < b ? a : b),
        'maxStock': stockValues.reduce((a, b) => a > b ? a : b),
      };
    } catch (e) {
      print('Error al obtener estadísticas de stock: $e');
      return {};
    }
  }

  // Obtener categorías únicas
  Future<List<String>> getUniqueCategories() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      Set<String> categories = {};
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = data['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('Error al obtener categorías: $e');
      return [];
    }
  }

  // Crear productos de ejemplo (para testing)
  Future<void> createSampleProducts() async {
    try {
      final sampleProducts = [
        {
          'name': 'Laptop Dell XPS 13',
          'description': 'Laptop ultrabook con procesador Intel i7',
          'price': 1299.99,
          'stock': 25,
          'category': 'Electrónicos',
          'imageUrl': '',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'isActive': true,
        },
        {
          'name': 'Mouse Logitech MX Master',
          'description': 'Mouse inalámbrico ergonómico',
          'price': 89.99,
          'stock': 150,
          'category': 'Accesorios',
          'imageUrl': '',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'isActive': true,
        },
        {
          'name': 'Monitor Samsung 27"',
          'description': 'Monitor 4K UHD de 27 pulgadas',
          'price': 449.99,
          'stock': 8,
          'category': 'Electrónicos',
          'imageUrl': '',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'isActive': true,
        },
        {
          'name': 'Teclado Mecánico RGB',
          'description': 'Teclado mecánico con iluminación RGB',
          'price': 129.99,
          'stock': 0,
          'category': 'Accesorios',
          'imageUrl': '',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'isActive': true,
        },
        {
          'name': 'Silla Ergonómica',
          'description': 'Silla de oficina ergonómica ajustable',
          'price': 299.99,
          'stock': 45,
          'category': 'Muebles',
          'imageUrl': '',
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'isActive': true,
        },
      ];

      for (var product in sampleProducts) {
        await _firestore.collection(_collection).add(product);
      }

      print('Productos de ejemplo creados exitosamente');
    } catch (e) {
      print('Error al crear productos de ejemplo: $e');
    }
  }
}