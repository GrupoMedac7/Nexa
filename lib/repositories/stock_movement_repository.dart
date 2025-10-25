import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexa/models/stock_movement.dart';
import 'package:nexa/services/logger.dart';

class StockMovementRepository {
  final _firestore = FirebaseFirestore.instance;
  String collection = 'stock_movements';

  Future<void> recordStockMovement(StockMovement movement) async {
    try {
      await _firestore.collection(collection).add(movement.toMap());
    } catch (e, stacktrace) {
      String error = '[StockMovementRepository] Error al registrar movimiento: $e';
      Logger.error(error, stacktrace);
      rethrow;
    }
  }

  Future<List<StockMovement>> getMovementsByProduct(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection(collection)
          .where('productId', isEqualTo: productId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return StockMovement.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e, stacktrace) {
      String error = '[StockMovementRepository] Error al obtener movimientos: $e';
      Logger.error(error, stacktrace);
      return [];
    }
  }

  Future<List<StockMovement>> getRecentMovements({int limit = 50}) async {
    try {
      final querySnapshot = await _firestore
          .collection(collection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        return StockMovement.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e, stacktrace) {
      String error = '[StockMovementRepository] Error al obtener movimientos recientes: $e';
      Logger.error(error, stacktrace);
      return [];
    }
  }

  Future<Map<String, dynamic>> getStockStatistics() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekAgo = today.subtract(const Duration(days: 7));

      // Movimientos de hoy
      final todayQuery = await _firestore
          .collection(collection)
          .where('timestamp', isGreaterThanOrEqualTo: today)
          .get();

      // Movimientos de la semana
      final weekQuery = await _firestore
          .collection(collection)
          .where('timestamp', isGreaterThanOrEqualTo: weekAgo)
          .get();

      int todayEntries = 0;
      int todayExits = 0;
      int weekEntries = 0;
      int weekExits = 0;

      for (var doc in todayQuery.docs) {
        final data = doc.data();
        final type = data['type'] as String;
        final quantity = data['quantity'] as int;
        
        if (type == 'entrada' || type == 'devolucion') {
          todayEntries += quantity;
        } else if (type == 'salida') {
          todayExits += quantity;
        }
      }

      for (var doc in weekQuery.docs) {
        final data = doc.data();
        final type = data['type'] as String;
        final quantity = data['quantity'] as int;
        
        if (type == 'entrada' || type == 'devolucion') {
          weekEntries += quantity;
        } else if (type == 'salida') {
          weekExits += quantity;
        }
      }

      return {
        'today': {
          'entries': todayEntries,
          'exits': todayExits,
          'net': todayEntries - todayExits,
        },
        'week': {
          'entries': weekEntries,
          'exits': weekExits,
          'net': weekEntries - weekExits,
        },
        'totalMovements': weekQuery.docs.length,
      };
    } catch (e, stacktrace) {
      String error = '[StockMovementRepository] Error al obtener estadísticas: $e';
      Logger.error(error, stacktrace);
      return {};
    }
  }
}