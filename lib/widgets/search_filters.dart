import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FiltersForm extends StatefulWidget {
  final Function(
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    int? maxStock,
  )
  onApply;

  const FiltersForm({super.key, required this.onApply});

  @override
  State<FiltersForm> createState() => _FiltersFormState();
}

class _FiltersFormState extends State<FiltersForm> {
  String? _selectedCategory;
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  final _minStockController = TextEditingController();
  final _maxStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text(
        'Advanced Filters',
        style: TextStyle(
          fontSize: 12
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  // Extract unique categories from Firestore
                  final categories = snapshot.data!.docs
                      .map(
                        (doc) =>
                            (doc.data() as Map<String, dynamic>)['category']
                                as String?,
                      )
                      .where((c) => c != null && c.isNotEmpty)
                      .toSet()
                      .toList();

                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Min Price'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _maxPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max Price'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minStockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Min Stock'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _maxStockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Max Stock'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _selectedCategory,
                    double.tryParse(_minPriceController.text),
                    double.tryParse(_maxPriceController.text),
                    int.tryParse(_minStockController.text),
                    int.tryParse(_maxStockController.text),
                  );
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
