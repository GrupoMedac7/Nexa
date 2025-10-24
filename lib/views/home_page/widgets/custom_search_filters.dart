import 'package:flutter/material.dart';

class CustomSearchFilters extends StatefulWidget {
  final List<DropdownMenuItem<String>> categories;
  final TextEditingController categoryController;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;
  final TextEditingController minStockController;
  final TextEditingController maxStockController;
  final void Function(String?)? onCategoryChanged;
  final void Function(double, double)? onPriceChanged;
  final void Function(double, double)? onStockChanged;

  const CustomSearchFilters({
    super.key,
    required this.categories,
    required this.categoryController,
    required this.minPriceController,
    required this.maxPriceController,
    required this.minStockController,
    required this.maxStockController,
    this.onCategoryChanged,
    this.onPriceChanged,
    this.onStockChanged,
  });

  @override
  State<CustomSearchFilters> createState() => _CustomSearchFiltersState();
}

class _CustomSearchFiltersState extends State<CustomSearchFilters> {
  final double _priceMax = 1000;
  final double _stockMax = 500;
  RangeValues _priceRange = RangeValues(0, 1);
  RangeValues _stockRange = RangeValues(0, 1);

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(0, _priceMax);
    _stockRange = RangeValues(0, _stockMax);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: const Row(
          children: [
            Icon(Icons.filter_list, color: Colors.blue),
            SizedBox(width: 8),
            Text('Filtros Avanzados', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        initiallyExpanded: true,
        onExpansionChanged: (expanded) {
          // Expansion state is handled automatically
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category dropdown
                const Text('Categoría:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.categoryController.text.isEmpty
                          ? null
                          : widget.categoryController.text,
                      hint: const Text("Seleccionar categoría"),
                      isExpanded: true,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text("Todas las categorías"),
                        ),
                        ...widget.categories,
                      ],
                      onChanged: (value) {
                        setState(() {
                          widget.categoryController.text = value ?? "";
                        });
                        if (widget.onCategoryChanged != null) {
                          widget.onCategoryChanged!(value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Price Range Slider
                const Text('Rango de Precio:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('€${_priceRange.start.round()} - €${_priceRange.end.round()}'),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: _priceMax,
                  divisions: 100,
                  labels: RangeLabels(
                    '€${_priceRange.start.round()}',
                    '€${_priceRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                      widget.minPriceController.text = values.start.toStringAsFixed(0);
                      widget.maxPriceController.text = values.end.toStringAsFixed(0);
                      if (widget.onPriceChanged != null) {
                        widget.onPriceChanged!(values.start, values.end);
                      }
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Stock Range Slider
                const Text('Rango de Stock:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${_stockRange.start.round()} - ${_stockRange.end.round()} unidades'),
                RangeSlider(
                  values: _stockRange,
                  min: 0,
                  max: _stockMax,
                  divisions: 100,
                  labels: RangeLabels(
                    _stockRange.start.round().toString(),
                    _stockRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _stockRange = values;
                      widget.minStockController.text = values.start.toStringAsFixed(0);
                      widget.maxStockController.text = values.end.toStringAsFixed(0);
                      if (widget.onStockChanged != null) {
                        widget.onStockChanged!(values.start, values.end);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
