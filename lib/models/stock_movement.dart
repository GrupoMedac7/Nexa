enum StockMovementType {
  entrada,  // Stock added
  salida,   // Stock removed
  ajuste,   // Stock adjustment
  devolucion // Stock return
}

class StockMovement {
  final String id;
  final String productId;
  final StockMovementType type;
  final int quantity;
  final int previousStock;
  final int newStock;
  final String reason;
  final String? userId;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  StockMovement({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.previousStock,
    required this.newStock,
    required this.reason,
    this.userId,
    required this.timestamp,
    this.metadata,
  });

  // Create from Firestore document
  factory StockMovement.fromMap(Map<String, dynamic> map, String docId) {
    return StockMovement(
      id: docId,
      productId: map['productId'] ?? '',
      type: StockMovementType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => StockMovementType.ajuste,
      ),
      quantity: map['quantity'] ?? 0,
      previousStock: map['previousStock'] ?? 0,
      newStock: map['newStock'] ?? 0,
      reason: map['reason'] ?? '',
      userId: map['userId'],
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'previousStock': previousStock,
      'newStock': newStock,
      'reason': reason,
      'userId': userId,
      'timestamp': timestamp,
      'metadata': metadata,
    };
  }

  String get typeDisplayName {
    switch (type) {
      case StockMovementType.entrada:
        return 'Entrada';
      case StockMovementType.salida:
        return 'Salida';
      case StockMovementType.ajuste:
        return 'Ajuste';
      case StockMovementType.devolucion:
        return 'Devolución';
    }
  }

  bool get isIncrease => type == StockMovementType.entrada || type == StockMovementType.devolucion;
  bool get isDecrease => type == StockMovementType.salida;
}