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
    categoryController = TextEditingController(
      text: widget.productModel.category,
    );
    priceController = TextEditingController(
      text: widget.productModel.price.toString(),
    );
    stockController = TextEditingController(
      text: widget.productModel.stock.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.productModel.description,
    );
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
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre del producto
                  Expanded(
                    child: isEditing
                        ? TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre del producto',
                            ),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppTheme.palette['black']),
                          )
                        : Text(
                            widget.productModel.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                  ),

                  // Marca
                  SizedBox(
                    width: 80,
                    child: isEditing
                        ? TextField(
                            controller: brandController,
                            decoration: const InputDecoration(
                              labelText: 'Marca',
                            ),
                          )
                        : Text(
                            widget.productModel.brand,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Image
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    color: AppTheme.palette['grey'],
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(widget.productModel.imageRef),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'En stock: ',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      // Stock
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
                              widget.productModel.stock.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ],
                  ),
                  // Price
                  isEditing
                      ? SizedBox(
                          width: 100,
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Precio',
                            ),
                          ),
                        )
                      : Text(
                          '${widget.productModel.price.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                ],
              ),
            ),

            SizedBox(height: isEditing ? 10 : 0),

            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Category
                  isEditing
                      ? Expanded(
                          child: TextField(
                            controller: categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Categoría',
                            ),
                          ),
                        )
                      : Chip(
                          label: Text(
                            widget.productModel.category,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),

                  const Spacer(),

                  Row(
                    children: [
                      // Edit / Check button
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.check_outlined : Icons.edit,
                          color: isEditing
                              ? AppTheme.palette['green']
                              : AppTheme.palette['orange'],
                          weight: 700,
                        ),
                        iconSize: 20,
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
                        icon: Icon(
                          Icons.delete,
                          color: AppTheme.palette['red'],
                          weight: 700,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          // TODO: Implement delete logic
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: isEditing ? 10 : 0),

            Padding(
              padding: EdgeInsets.only(left: 15),
              // Description
              child: isEditing
                  ? TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                    )
                  : Text(
                      widget.productModel.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
