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
  bool _isExpanded = false;
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
    return ExpansionTile(
      title: const Text('Filters'),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category dropdown
            Center(
              child: DropdownButton<String>(
                value: widget.categoryController.text.isEmpty
                    ? null
                    : widget.categoryController.text,
                hint: Text(
                  widget.categoryController.text.isEmpty
                      ? "Select category"
                      : widget.categoryController.text,
                ),
                items: widget.categories,
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

            const SizedBox(height: 16),

            // Price Range Slider
            const Text('Price'),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: _priceMax,
              divisions: 100,
              labels: RangeLabels(
                _priceRange.start.round().toString(),
                _priceRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                  widget.minPriceController.text = values.start.toStringAsFixed(
                    0,
                  );
                  widget.maxPriceController.text = values.end.toStringAsFixed(
                    0,
                  );
                  if (widget.onPriceChanged != null) {
                    widget.onPriceChanged!(values.start, values.end);
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // Stock Range Slider
            const Text('Stock'),
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
                  widget.minStockController.text = values.start.toStringAsFixed(
                    0,
                  );
                  widget.maxStockController.text = values.end.toStringAsFixed(
                    0,
                  );
                  if (widget.onStockChanged != null) {
                    widget.onStockChanged!(values.start, values.end);
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
