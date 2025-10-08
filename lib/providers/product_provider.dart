import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();

  ProductModel? _product;
  ProductModel? get product => _product;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadProduct(String productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedProduct = await _repository.getProductById(productId);
      if (fetchedProduct != null) {
        _product = fetchedProduct;
      } else {
        _error = 'Product no encontrado';
      }
    } catch (e) {
      _error = 'Error al cargar producto';
      print('[Product provider] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProduct() {
    _product = null;
    _error = null;
    notifyListeners();
  }
}