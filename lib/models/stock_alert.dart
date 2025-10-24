import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';

enum StockAlertLevel {
  critical, // Stock muy bajo (rojo)
  warning,  // Stock bajo (amarillo)
  normal    // Stock normal (verde)
}

class StockAlert {
  final String productId;
  final String productName;
  final int currentStock;
  final int minimumStock;
  final StockAlertLevel level;
  final DateTime lastUpdated;

  StockAlert({
    required this.productId,
    required this.productName,
    required this.currentStock,
    required this.minimumStock,
    required this.level,
    required this.lastUpdated,
  });

  factory StockAlert.fromProduct(ProductModel product, {int? customMinimum}) {
    final minStock = customMinimum ?? _getDefaultMinimumStock(product.category);
    final level = _calculateAlertLevel(product.stock, minStock);
    
    return StockAlert(
      productId: product.id,
      productName: product.name,
      currentStock: product.stock,
      minimumStock: minStock,
      level: level,
      lastUpdated: DateTime.now(),
    );
  }

  static StockAlertLevel _calculateAlertLevel(int currentStock, int minimumStock) {
    if (currentStock <= 0) {
      return StockAlertLevel.critical;
    } else if (currentStock <= minimumStock) {
      return StockAlertLevel.warning;
    } else {
      return StockAlertLevel.normal;
    }
  }

  static int _getDefaultMinimumStock(String category) {
    // Define minimum stock levels based on category
    switch (category.toLowerCase()) {
      case 'electronics':
      case 'electrónicos':
        return 5;
      case 'clothing':
      case 'ropa':
        return 10;
      case 'food':
      case 'comida':
        return 20;
      case 'books':
      case 'libros':
        return 3;
      default:
        return 5;
    }
  }

  String get levelDisplayName {
    switch (level) {
      case StockAlertLevel.critical:
        return 'Crítico';
      case StockAlertLevel.warning:
        return 'Advertencia';
      case StockAlertLevel.normal:
        return 'Normal';
    }
  }

  Color get levelColor {
    switch (level) {
      case StockAlertLevel.critical:
        return Colors.red;
      case StockAlertLevel.warning:
        return Colors.orange;
      case StockAlertLevel.normal:
        return Colors.green;
    }
  }

  // Alias para compatibilidad
  Color get color => levelColor;
  
  // Alias para compatibilidad  
  String get levelText => levelDisplayName;
  
  // Alias para compatibilidad
  int get minStock => minimumStock;

  IconData get levelIcon {
    switch (level) {
      case StockAlertLevel.critical:
        return Icons.error;
      case StockAlertLevel.warning:
        return Icons.warning;
      case StockAlertLevel.normal:
        return Icons.check_circle;
    }
  }

  bool get needsAttention => level != StockAlertLevel.normal;
}