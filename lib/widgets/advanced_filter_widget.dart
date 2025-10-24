import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_filter.dart';

class AdvancedFilterWidget extends StatefulWidget {
  final ProductFilter initialFilter;
  final Function(ProductFilter) onFilterChanged;
  final List<String> categories;

  const AdvancedFilterWidget({
    super.key,
    required this.initialFilter,
    required this.onFilterChanged,
    this.categories = const [],
  });

  @override
  State<AdvancedFilterWidget> createState() => _AdvancedFilterWidgetState();
}

class _AdvancedFilterWidgetState extends State<AdvancedFilterWidget> {
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _searchController;
  
  String? _selectedCategory;
  bool? _isActive;
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadInitialValues();
  }

  void _initializeControllers() {
    _minStockController = TextEditingController();
    _maxStockController = TextEditingController();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _searchController = TextEditingController();
  }

  void _loadInitialValues() {
    final filter = widget.initialFilter;
    _minStockController.text = filter.minStock?.toString() ?? '';
    _maxStockController.text = filter.maxStock?.toString() ?? '';
    _minPriceController.text = filter.minPrice?.toString() ?? '';
    _maxPriceController.text = filter.maxPrice?.toString() ?? '';
    _searchController.text = filter.searchQuery ?? '';
    _selectedCategory = filter.category;
    _isActive = filter.isActive;
    _selectedDateRange = filter.dateRange;
  }

  @override
  void dispose() {
    _minStockController.dispose();
    _maxStockController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filter = ProductFilter(
      category: _selectedCategory,
      minPrice: _minPriceController.text.isEmpty 
          ? null 
          : double.tryParse(_minPriceController.text),
      maxPrice: _maxPriceController.text.isEmpty 
          ? null 
          : double.tryParse(_maxPriceController.text),
      minStock: _minStockController.text.isEmpty 
          ? null 
          : int.tryParse(_minStockController.text),
      maxStock: _maxStockController.text.isEmpty 
          ? null 
          : int.tryParse(_maxStockController.text),
      searchQuery: _searchController.text.isEmpty 
          ? null 
          : _searchController.text,
      isActive: _isActive,
      dateRange: _selectedDateRange,
    );
    
    widget.onFilterChanged(filter);
  }

  void _clearFilters() {
    setState(() {
      _minStockController.clear();
      _maxStockController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _searchController.clear();
      _selectedCategory = null;
      _isActive = null;
      _selectedDateRange = null;
    });
    
    widget.onFilterChanged(const ProductFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtros Avanzados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Limpiar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      child: const Text('Aplicar'),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Búsqueda por nombre
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar producto',
                hintText: 'Nombre del producto...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filtros de Stock (Principal Feature)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.inventory_2, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Filtros de Stock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minStockController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Stock Mínimo',
                            hintText: '0',
                            prefixIcon: Icon(Icons.arrow_upward),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _maxStockController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Stock Máximo',
                            hintText: '1000',
                            prefixIcon: Icon(Icons.arrow_downward),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filtros de Precio
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Filtros de Precio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Precio Mínimo',
                            hintText: '0.00',
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Precio Máximo',
                            hintText: '999.99',
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Categoría y Estado
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todas las categorías'),
                      ),
                      ...widget.categories.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<bool?>(
                    initialValue: _isActive,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.toggle_on),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Activos'),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text('Inactivos'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _isActive = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Selector de fecha
            InkWell(
              onTap: () async {
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDateRange: _selectedDateRange,
                );
                
                if (picked != null) {
                  setState(() {
                    _selectedDateRange = picked;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(width: 8),
                    Text(
                      _selectedDateRange == null
                          ? 'Seleccionar rango de fechas'
                          : '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}',
                    ),
                    if (_selectedDateRange != null) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDateRange = null;
                          });
                        },
                        child: const Icon(Icons.clear, size: 20),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}