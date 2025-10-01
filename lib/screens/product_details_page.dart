import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final String category;
  final int stock;
  final double price;

  const ProductDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.stock,
    required this.price,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController stockController;
  late TextEditingController priceController;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    categoryController = TextEditingController(text: widget.category);
    stockController = TextEditingController(text: widget.stock.toString());
    priceController = TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    stockController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void onEditPressed() async {
    if (isEditing) {
      try {
        final updatedProduct = ProductModel(
          id: widget.id,
          name: nameController.text,
          description: descriptionController.text,
          category: categoryController.text,
          stock: int.tryParse(stockController.text) ?? 0,
          price: double.tryParse(priceController.text) ?? 0.0,
        );

        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update(updatedProduct.toMap());

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product: $e')),
        );
      }
    }

    setState(() {
      isEditing = !isEditing;
    });
  }

void onDeletePressed() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: const Text('Are you sure you want to delete this product?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  try {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.id)
        .delete();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully')),
    );

    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting product: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: isEditing
                          ? TextField(controller: nameController)
                          : Text(
                              nameController.text,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                    isEditing
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                suffixText: '€',
                              ),
                            ),
                          )
                        : Text(
                            '${priceController.text}€',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green),
                          ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category & Stock Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isEditing
                        ? SizedBox(
                            width: 100,
                            child: TextField(
                              controller: stockController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                              ),
                            ),
                          )
                        : Text(
                            'Stock: ${stockController.text}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    isEditing
                        ? SizedBox(
                            width: 150,
                            child: TextField(
                              controller: categoryController,
                              decoration:
                                  const InputDecoration(labelText: 'Category'),
                            ),
                          )
                        : Chip(
                            label: Text(categoryController.text),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(fontSize: 12),
                          ),
                  ],
                ),

                const Divider(),
                const SizedBox(height: 8),

                // Description
                isEditing
                    ? TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      )
                    : Text(
                        descriptionController.text,
                        style: const TextStyle(fontSize: 14),
                      ),

                const SizedBox(height: 16),

                // Edit / Delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        isEditing ? Icons.check : Icons.edit,
                        color: Colors.orange,
                      ),
                      onPressed: onEditPressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDeletePressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}