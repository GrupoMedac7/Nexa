import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/models/stock_movement.dart';
import 'package:nexa/models/stock_alert.dart';
import 'package:nexa/providers/stock_control_provider.dart';
import 'package:nexa/widgets/custom_snack_bar.dart';

class StockControlPage extends StatefulWidget {
  final ProductModel? initialProduct;

  const StockControlPage({super.key, this.initialProduct});

  @override
  State<StockControlPage> createState() => _StockControlPageState();
}

class _StockControlPageState extends State<StockControlPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StockControlProvider>().loadStockData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockControlProvider>(
      builder: (context, stockProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Control de Stock'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Alertas', icon: Icon(Icons.warning)),
                Tab(text: 'Movimientos', icon: Icon(Icons.history)),
                Tab(text: 'Estadísticas', icon: Icon(Icons.analytics)),
              ],
            ),
          ),
          body: stockProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAlertsTab(stockProvider.alerts),
                    _buildMovementsTab(stockProvider.recentMovements),
                    _buildStatisticsTab(stockProvider.statistics, stockProvider.alerts),
                  ],
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showStockMovementDialog,
            child: const Icon(Icons.add),
            tooltip: 'Nuevo Movimiento',
          ),
        );
      },
    );
  }

  Widget _buildAlertsTab(List<StockAlert> alerts) {
    if (alerts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text('No hay alertas de stock', 
                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Text('Todos los productos tienen stock suficiente'),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StockControlProvider>().loadStockData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return _buildAlertCard(alert);
        },
      ),
    );
  }

  Widget _buildAlertCard(StockAlert alert) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          Icons.warning,
          color: alert.color,
          size: 32,
        ),
        title: Text(
          alert.productName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock actual: ${alert.currentStock}'),
            Text('Mínimo requerido: ${alert.minStock}'),
            Text(
              alert.levelText,
              style: TextStyle(
                color: alert.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _showStockAdjustmentDialog(alert.productId),
          child: const Text('Ajustar'),
        ),
      ),
    );
  }

  Widget _buildMovementsTab(List<StockMovement> movements) {
    if (movements.isEmpty) {
      return const Center(
        child: Text('No hay movimientos recientes'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<StockControlProvider>().loadStockData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: movements.length,
        itemBuilder: (context, index) {
          final movement = movements[index];
          return _buildMovementCard(movement);
        },
      ),
    );
  }

  Widget _buildMovementCard(StockMovement movement) {
    IconData icon;
    Color color;

    switch (movement.type) {
      case StockMovementType.entrada:
        icon = Icons.add_circle;
        color = Colors.green;
        break;
      case StockMovementType.salida:
        icon = Icons.remove_circle;
        color = Colors.red;
        break;
      case StockMovementType.ajuste:
        icon = Icons.edit;
        color = Colors.orange;
        break;
      case StockMovementType.devolucion:
        icon = Icons.undo;
        color = Colors.blue;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(movement.type.name.toUpperCase()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cantidad: ${movement.quantity}'),
            Text('${movement.previousStock} → ${movement.newStock}'),
            Text('Razón: ${movement.reason}'),
            Text(
              'Fecha: ${movement.timestamp.toLocal().toString().split('.')[0]}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsTab(Map<String, dynamic> statistics, List<StockAlert> alerts) {
    if (statistics.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildStatCard('Total de Movimientos', 
                        statistics['totalMovements']?.toString() ?? '0',
                        Icons.swap_horiz),
          const SizedBox(height: 16),
          _buildStatCard('Entradas del Mes', 
                        statistics['entriesThisMonth']?.toString() ?? '0',
                        Icons.add_circle, Colors.green),
          const SizedBox(height: 16),
          _buildStatCard('Salidas del Mes', 
                        statistics['exitsThisMonth']?.toString() ?? '0',
                        Icons.remove_circle, Colors.red),
          const SizedBox(height: 16),
          _buildStatCard('Productos con Stock Crítico', 
                        alerts.where((a) => a.level == StockAlertLevel.critical).length.toString(),
                        Icons.warning, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, [Color? color]) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color ?? Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStockMovementDialog() {
    // Implementar diálogo para crear nuevo movimiento
    showDialog(
      context: context,
      builder: (context) => const StockMovementDialog(),
    );
  }

  void _showStockAdjustmentDialog(String productId) {
    // Implementar diálogo para ajustar stock específico
    showDialog(
      context: context,
      builder: (context) => StockAdjustmentDialog(productId: productId),
    );
  }
}

class StockMovementDialog extends StatefulWidget {
  const StockMovementDialog({super.key});

  @override
  State<StockMovementDialog> createState() => _StockMovementDialogState();
}

class _StockMovementDialogState extends State<StockMovementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  
  StockMovementType _selectedType = StockMovementType.entrada;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Movimiento de Stock'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selector de tipo de movimiento
            DropdownButtonFormField<StockMovementType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de Movimiento'),
              items: StockMovementType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de cantidad
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una cantidad';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Ingrese una cantidad válida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de razón
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Razón'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una razón';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveMovement,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  void _saveMovement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Implementar la lógica de guardado
      Navigator.of(context).pop();
      CustomSnackBar.showSuccess(context, 'Movimiento registrado exitosamente');
    } catch (e) {
      CustomSnackBar.showError(context, 'Error al registrar movimiento: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class StockAdjustmentDialog extends StatefulWidget {
  final String productId;

  const StockAdjustmentDialog({super.key, required this.productId});

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajustar Stock'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Nueva Cantidad'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una cantidad';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity < 0) {
                  return 'Ingrese una cantidad válida';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Razón del Ajuste'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese una razón';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _adjustStock,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Ajustar'),
        ),
      ],
    );
  }

  void _adjustStock() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final stockProvider = context.read<StockControlProvider>();
      final quantity = int.parse(_quantityController.text);
      final reason = _reasonController.text;

      final success = await stockProvider.adjustStock(
        productId: widget.productId,
        newQuantity: quantity,
        reason: reason,
      );

      if (success) {
        Navigator.of(context).pop();
        CustomSnackBar.showSuccess(context, 'Stock ajustado exitosamente');
      } else {
        CustomSnackBar.showError(context, 'Error al ajustar el stock');
      }
    } catch (e) {
      CustomSnackBar.showError(context, 'Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}