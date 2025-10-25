import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/models/stock_movement.dart';
import 'package:nexa/models/stock_alert.dart';
import 'package:nexa/repositories/product_repository.dart';
import 'package:nexa/repositories/stock_movement_repository.dart';
import 'package:nexa/services/logger.dart';

class StockControlService {
  final ProductRepository _productRepository = ProductRepository();
  final StockMovementRepository _stockMovementRepository = StockMovementRepository();

  /// Actualiza el stock de un producto y registra el movimiento
  Future<bool> updateStock({
    required String productId,
    required int newQuantity,
    required StockMovementType movementType,
    required String reason,
    String? userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Obtener el producto actual
      final product = await _productRepository.getProductById(productId);
      if (product == null) {
        throw Exception('Producto no encontrado');
      }

      final previousStock = product.stock;
      final quantityChange = newQuantity - previousStock;

      // Crear el movimiento de stock
      final movement = StockMovement(
        id: '', // Se asignará en Firestore
        productId: productId,
        type: movementType,
        quantity: quantityChange.abs(),
        previousStock: previousStock,
        newStock: newQuantity,
        reason: reason,
        userId: userId,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      // Actualizar el producto con el nuevo stock
      final updatedProduct = product.copyWith(
        stock: newQuantity,
        updatedAt: DateTime.now(),
      );

      // Realizar la transacción
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Actualizar el producto
        final productRef = FirebaseFirestore.instance
            .collection('products')
            .doc(productId);
        transaction.update(productRef, updatedProduct.toMap());

        // Registrar el movimiento
        final movementRef = FirebaseFirestore.instance
            .collection('stock_movements')
            .doc();
        transaction.set(movementRef, movement.toMap());
      });

      return true;
    } catch (e, stacktrace) {
      String error = '[StockControlService] Error al actualizar stock: $e';
      Logger.error(error, stacktrace);
      return false;
    }
  }

  /// Reduce el stock del producto (por ejemplo, por una venta)
  Future<bool> reduceStock({
    required String productId,
    required int quantity,
    required String reason,
    String? userId,
  }) async {
    final product = await _productRepository.getProductById(productId);
    if (product == null) return false;

    final newStock = product.stock - quantity;
    if (newStock < 0) {
      throw Exception('Stock insuficiente. Stock actual: ${product.stock}');
    }

    return await updateStock(
      productId: productId,
      newQuantity: newStock,
      movementType: StockMovementType.salida,
      reason: reason,
      userId: userId,
      metadata: {'originalQuantity': quantity},
    );
  }

  /// Añade stock al producto (por ejemplo, por una compra)
  Future<bool> addStock({
    required String productId,
    required int quantity,
    required String reason,
    String? userId,
  }) async {
    final product = await _productRepository.getProductById(productId);
    if (product == null) return false;

    final newStock = product.stock + quantity;

    return await updateStock(
      productId: productId,
      newQuantity: newStock,
      movementType: StockMovementType.entrada,
      reason: reason,
      userId: userId,
      metadata: {'addedQuantity': quantity},
    );
  }

  /// Ajusta el stock a un valor específico
  Future<bool> adjustStock({
    required String productId,
    required int newQuantity,
    required String reason,
    String? userId,
  }) async {
    return await updateStock(
      productId: productId,
      newQuantity: newQuantity,
      movementType: StockMovementType.ajuste,
      reason: reason,
      userId: userId,
    );
  }

  /// Obtiene las alertas de stock bajo
  Future<List<StockAlert>> getStockAlerts() async {
    try {
      final products = await _productRepository.getAllProducts();
      final alerts = <StockAlert>[];

      for (final product in products) {
        final alert = StockAlert.fromProduct(product);
        if (alert.needsAttention) {
          alerts.add(alert);
        }
      }

      // Ordenar por nivel de criticidad
      alerts.sort((a, b) {
        if (a.level == b.level) {
          return a.currentStock.compareTo(b.currentStock);
        }
        return a.level.index.compareTo(b.level.index);
      });

      return alerts;
    } catch (e, stacktrace) {
      String error = '[StockControlService] Error al obtener alertas: $e';
      Logger.error(error, stacktrace);
      return [];
    }
  }

  /// Obtiene el historial de movimientos de un producto
  Future<List<StockMovement>> getProductStockHistory(String productId) async {
    return await _stockMovementRepository.getMovementsByProduct(productId);
  }

  /// Obtiene movimientos recientes de stock
  Future<List<StockMovement>> getRecentStockMovements({int limit = 50}) async {
    return await _stockMovementRepository.getRecentMovements(limit: limit);
  }

  /// Obtiene estadísticas de stock
  Future<Map<String, dynamic>> getStockStatistics() async {
    return await _stockMovementRepository.getStockStatistics();
  }

  /// Verifica si un producto tiene stock suficiente
  Future<bool> hasEnoughStock(String productId, int requiredQuantity) async {
    final product = await _productRepository.getProductById(productId);
    return product != null && product.stock >= requiredQuantity;
  }

  /// Obtiene productos con stock crítico
  Future<List<ProductModel>> getCriticalStockProducts() async {
    final alerts = await getStockAlerts();
    final criticalProductIds = alerts
        .where((alert) => alert.level == StockAlertLevel.critical)
        .map((alert) => alert.productId)
        .toList();

    final products = <ProductModel>[];
    for (final productId in criticalProductIds) {
      final product = await _productRepository.getProductById(productId);
      if (product != null) {
        products.add(product);
      }
    }

    return products;
  }
}