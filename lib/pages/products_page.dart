import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/product_filter.dart';
import '../services/product_service.dart';
import '../widgets/advanced_filter_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<String> _categories = [];
  ProductFilter _currentFilter = const ProductFilter();
  bool _isLoading = false;
  bool _showFilters = false;
  Map<String, dynamic> _stockStats = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar categorías
      _categories = await _productService.getUniqueCategories();
      
      // Cargar productos iniciales
      await _loadProducts();
      
      // Cargar estadísticas de stock
      _stockStats = await _productService.getStockStatistics();
    } catch (e) {
      _showErrorSnackbar('Error al cargar datos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getProductsWithFilters(_currentFilter);
      setState(() {
        _products = products;
      });
    } catch (e) {
      _showErrorSnackbar('Error al cargar productos: $e');
    }
  }

  void _onFilterChanged(ProductFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _loadProducts();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildStockIndicator(int stock) {
    Color color;
    String status;
    
    if (stock == 0) {
      color = Colors.red;
      status = 'Sin Stock';
    } else if (stock <= 10) {
      color = Colors.orange;
      status = 'Stock Bajo';
    } else if (stock <= 50) {
      color = Colors.blue;
      status = 'Stock Normal';
    } else {
      color = Colors.green;
      status = 'Stock Alto';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        '$stock - $status',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStockIndicator(product.stock),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Precio: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Categoría: ${product.category}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 20,
                      color: product.stock > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product.stock} unidades',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: product.stock > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    if (_stockStats.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas de Stock',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildStatItem(
                  'Total Productos',
                  '${_stockStats['totalProducts']}',
                  Icons.inventory,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Stock Total',
                  '${_stockStats['totalStock']}',
                  Icons.storage,
                  Colors.green,
                ),
                _buildStatItem(
                  'Stock Promedio',
                  '${(_stockStats['averageStock'] as double).toStringAsFixed(1)}',
                  Icons.trending_up,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Sin Stock',
                  '${_stockStats['outOfStockCount']}',
                  Icons.warning,
                  Colors.red,
                ),
                _buildStatItem(
                  'Stock Bajo',
                  '${_stockStats['lowStockCount']}',
                  Icons.priority_high,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Stock Alto',
                  '${_stockStats['highStockCount']}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos - Filtros Avanzados'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_alt_off : Icons.filter_alt),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros avanzados (colapsables)
          if (_showFilters)
            AdvancedFilterWidget(
              initialFilter: _currentFilter,
              onFilterChanged: _onFilterChanged,
              categories: _categories,
            ),
          
          // Estadísticas de stock
          _buildStatsCard(),
          
          // Lista de productos
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron productos con los filtros aplicados',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(_products[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Crear productos de ejemplo
          await _productService.createSampleProducts();
          _loadInitialData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Productos de ejemplo creados'),
              backgroundColor: Colors.green,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}