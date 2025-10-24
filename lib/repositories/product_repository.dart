import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/services/logger.dart';

class ProductRepository {
  final _firestore = FirebaseFirestore.instance;
  String collection = 'products';

  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection(collection).doc(productId).get();
      if (doc.exists && doc.data() != null) {
        return ProductModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e, stacktrace) {
      String error = '[product repository] Error al obtener producto: $e';
      Logger.error(error, stacktrace);
    }
    return null;
  }

  Future<List<ProductModel>> getProducts({
    String? searchQuery,
    String? category,
    int? minPrice,
    int? maxPrice,
    int? minStock,
    int? maxStock,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      if (minStock != null) {
        query = query.where('stock', isGreaterThanOrEqualTo: minStock);
      }
      if (maxStock != null) {
        query = query.where('stock', isLessThanOrEqualTo: maxStock);
      }

      final querySnapshot = await query.get();

      List<ProductModel> products = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data, doc.id);
      }).toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        products = products
            .where((p) => p.name.toLowerCase().contains(lowerQuery))
            .toList();
      }

      return products;
    } catch (e, stacktrace) {
      Logger.error('[Product repository] Error fetching filtered products: $e', stacktrace);
      return [];
    }
  }

  Future<void> saveProduct(ProductModel product) async {
    try {
      await _firestore.collection(collection).add(product.toMap());
    } catch (e, stacktrace) {
      String error = '[Product repository] Error al guardar producto: $e';
      Logger.error(error, stacktrace);
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(collection).doc(productId).delete();
    } catch (e, stacktrace) {
      String error = '[Product repository] Error al borrar producto: $e';
      Logger.error(error, stacktrace);
    }
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore.collection(collection).get();

      final productList = querySnapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();

      return productList;
    } catch (e, stacktrace) {
      String error = '[Product repository] Error al obtener productos: $e';
      Logger.error(error, stacktrace);
      return [];
    }
  }
}