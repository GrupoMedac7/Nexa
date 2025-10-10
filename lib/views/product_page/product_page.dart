import 'package:flutter/material.dart';
import 'package:nexa/core/theme_provider.dart';
import 'package:nexa/models/product_model.dart';

class ProductPage extends StatefulWidget {
  final ProductModel productModel;

  const ProductPage({super.key, required this.productModel});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isEditing = false;

  late TextEditingController nameController;
  late TextEditingController brandController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.productModel.name);
    brandController = TextEditingController(text: widget.productModel.brand);
    categoryController = TextEditingController(text: widget.productModel.category);
    priceController = TextEditingController(text: widget.productModel.price.toString());
    stockController = TextEditingController(text: widget.productModel.stock.toString());
    descriptionController = TextEditingController(text: widget.productModel.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    brandController.dispose();
    categoryController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name + Brand row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: isEditing
                      ? TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        )
                      : Text(
                          widget.productModel.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isEditing
                      ? TextField(
                          controller: brandController,
                          decoration: const InputDecoration(labelText: 'Brand'),
                        )
                      : Text(
                          widget.productModel.brand,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Category + Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category chip or editable text
                isEditing
                    ? Expanded(
                        child: TextField(
                          controller: categoryController,
                          decoration: const InputDecoration(labelText: 'Category'),
                        ),
                      )
                    : Chip(
                        label: Text(
                          widget.productModel.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),

                // Spacer to push buttons to the right
                const Spacer(),

                // Buttons
                Row(
                  children: [
                    // Edit / Check button
                    IconButton(
                      icon: Icon(isEditing ? Icons.check : Icons.edit),
                      onPressed: () {
                        setState(() {
                          if (isEditing) {
                            // TODO: Save logic
                          }
                          isEditing = !isEditing;
                        });
                      },
                    ),

                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // TODO: Implement delete logic
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Image
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: AppTheme.palette['grey'],
                image: DecorationImage(
                  image: NetworkImage(widget.productModel.imageRef),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Price + Stock row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isEditing
                    ? SizedBox(
                        width: 100,
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Price'),
                        ),
                      )
                    : Text(
                        widget.productModel.price.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                isEditing
                    ? SizedBox(
                        width: 100,
                        child: TextField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Stock'),
                        ),
                      )
                    : Text(
                        widget.productModel.stock.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ],
            ),

            const SizedBox(height: 12),

            // Description
            isEditing
                ? TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Description'),
                  )
                : Text(
                    widget.productModel.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
          ],
        ),
      ),
    );
  }
}