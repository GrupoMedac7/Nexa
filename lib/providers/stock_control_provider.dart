import 'package:flutter/foundation.dart';
import 'package:nexa/models/stock_alert.dart';
import 'package:nexa/models/stock_movement.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/services/stock_control_service.dart';

class StockControlProvider extends ChangeNotifier {
  final StockControlService _stockService = StockControlService();
  
  List<StockAlert> _alerts = [];
  List<StockMovement> _recentMovements = [];
  Map<String, dynamic> _statistics = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<StockAlert> get alerts => _alerts;
  List<StockMovement> get recentMovements => _recentMovements;
  Map<String, dynamic> get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Alertas críticas (para mostrar en la UI principal)
  List<StockAlert> get criticalAlerts => 
      _alerts.where((alert) => alert.level == StockAlertLevel.critical).toList();

  // Número total de alertas
  int get totalAlerts => _alerts.length;

  // Número de alertas críticas
  int get criticalAlertsCount => criticalAlerts.length;

  /// Carga todos los datos del control de stock
  Future<void> loadStockData() async {
    _setLoading(true);
    _error = null;

    try {
      final results = await Future.wait([
        _stockService.getStockAlerts(),
        _stockService.getRecentStockMovements(),
        _stockService.getStockStatistics(),
      ]);

      _alerts = results[0] as List<StockAlert>;
      _recentMovements = results[1] as List<StockMovement>;
      _statistics = results[2] as Map<String, dynamic>;

      notifyListeners();
    } catch (e) {
      _error = 'Error al cargar datos de stock: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el stock de un producto
  Future<bool> updateStock({
    required String productId,
    required int newQuantity,
    required StockMovementType movementType,
    required String reason,
    String? userId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final success = await _stockService.updateStock(
        productId: productId,
        newQuantity: newQuantity,
        movementType: movementType,
        reason: reason,
        userId: userId,
        metadata: metadata,
      );

      if (success) {
        // Recargar datos después de la actualización
        await loadStockData();
      }

      return success;
    } catch (e) {
      _error = 'Error al actualizar stock: $e';
      notifyListeners();
      return false;
    }
  }

  /// Reduce el stock (por ejemplo, por una venta)
  Future<bool> reduceStock({
    required String productId,
    required int quantity,
    required String reason,
    String? userId,
  }) async {
    try {
      final success = await _stockService.reduceStock(
        productId: productId,
        quantity: quantity,
        reason: reason,
        userId: userId,
      );

      if (success) {
        await loadStockData();
      }

      return success;
    } catch (e) {
      _error = 'Error al reducir stock: $e';
      notifyListeners();
      return false;
    }
  }

  /// Añade stock (por ejemplo, por una compra)
  Future<bool> addStock({
    required String productId,
    required int quantity,
    required String reason,
    String? userId,
  }) async {
    try {
      final success = await _stockService.addStock(
        productId: productId,
        quantity: quantity,
        reason: reason,
        userId: userId,
      );

      if (success) {
        await loadStockData();
      }

      return success;
    } catch (e) {
      _error = 'Error al añadir stock: $e';
      notifyListeners();
      return false;
    }
  }

  /// Ajusta el stock a un valor específico
  Future<bool> adjustStock({
    required String productId,
    required int newQuantity,
    required String reason,
    String? userId,
  }) async {
    try {
      final success = await _stockService.adjustStock(
        productId: productId,
        newQuantity: newQuantity,
        reason: reason,
        userId: userId,
      );

      if (success) {
        await loadStockData();
      }

      return success;
    } catch (e) {
      _error = 'Error al ajustar stock: $e';
      notifyListeners();
      return false;
    }
  }

  /// Obtiene el historial de movimientos de un producto específico
  Future<List<StockMovement>> getProductStockHistory(String productId) async {
    try {
      return await _stockService.getProductStockHistory(productId);
    } catch (e) {
      _error = 'Error al obtener historial: $e';
      notifyListeners();
      return [];
    }
  }

  /// Verifica si un producto tiene stock suficiente
  Future<bool> hasEnoughStock(String productId, int requiredQuantity) async {
    try {
      return await _stockService.hasEnoughStock(productId, requiredQuantity);
    } catch (e) {
      debugPrint('Error verificando stock: $e');
      return false;
    }
  }

  /// Obtiene productos con stock crítico
  Future<List<ProductModel>> getCriticalStockProducts() async {
    try {
      return await _stockService.getCriticalStockProducts();
    } catch (e) {
      _error = 'Error al obtener productos críticos: $e';
      notifyListeners();
      return [];
    }
  }

  /// Refresca solo las alertas (más rápido que cargar todo)
  Future<void> refreshAlerts() async {
    try {
      _alerts = await _stockService.getStockAlerts();
      notifyListeners();
    } catch (e) {
      _error = 'Error al refrescar alertas: $e';
      notifyListeners();
    }
  }

  /// Refresca solo los movimientos recientes
  Future<void> refreshMovements() async {
    try {
      _recentMovements = await _stockService.getRecentStockMovements();
      notifyListeners();
    } catch (e) {
      _error = 'Error al refrescar movimientos: $e';
      notifyListeners();
    }
  }

  /// Limpia el error actual
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}