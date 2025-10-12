import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/services/logger.dart';
import 'package:nexa/widgets/custom_snack_bar.dart';

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
    nameController = TextEditingController(
      text: widget.productModel.name,
    );
    brandController = TextEditingController(
      text: widget.productModel.brand,
    );
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

  void onEditPressed() async {
    if (isEditing) {
      try {
        final ProductModel editedProduct = ProductModel(
          id: widget.productModel.id,
          name: nameController.text,
          brand: brandController.text,
          category: categoryController.text,
          price:
              double.tryParse(priceController.text) ??
              widget.productModel.price,
          stock:
              int.tryParse(stockController.text) ?? widget.productModel.stock,
          description: descriptionController.text,
        );

        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productModel.id)
            .update(editedProduct.toMap());

        if (!mounted) return;

        CustomSnackBar.show(
          context,
          'Producto editado correctamente!',
          mode: CustomSnackBarMode.succ,
        );
      } catch (e, stack) {
        if (!mounted) return;

        CustomSnackBar.show(
          context,
          'Error al actualizar el producto',
          mode: CustomSnackBarMode.err,
        );

        Logger.error('Error al actualizar el producto: $e', stack);
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
          .doc(widget.productModel.id)
          .delete();

      if (!mounted) return;

      CustomSnackBar.show(
        context,
        'Producto borrado correctamente!',
        mode: CustomSnackBarMode.succ,
      );

      Navigator.pop(context);
    } catch (e, stack) {
      if (!mounted) return;

      CustomSnackBar.show(
        context,
        'Error al borrar el producto',
        mode: CustomSnackBarMode.err,
      );

      Logger.error('Error al borrar el producto: $e', stack);
    }
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
                            decoration: InputDecoration(
                              labelText: 'Nombre del producto',
                            ),
                            style: Theme.of(context).textTheme.titleLarge
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
                            decoration: InputDecoration(labelText: 'Marca'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppTheme.palette['black']),
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

            // Imagen
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
                                decoration: InputDecoration(labelText: 'Stock'),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.palette['black'],
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
                            decoration: InputDecoration(labelText: 'Precio'),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppTheme.palette['black']),
                          ),
                        )
                      : Text(
                          '${widget.productModel.price.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 1,
                                    color: AppTheme.palette['grey']!,
                                  ),
                                ],
                              ),
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
                            decoration: InputDecoration(labelText: 'Categoría'),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.palette['black']),
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
                      // Edit / check button
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.check_outlined : Icons.edit,
                          color: isEditing
                              ? (AppTheme.isDarkMode.value ? Colors.white : Colors.amber)
                              : (AppTheme.isDarkMode.value ? Colors.white : Colors.green),
                          weight: 700,
                        ),
                        iconSize: 20,
                        onPressed: () => onEditPressed(),
                      ),

                      // Delete button
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: (AppTheme.isDarkMode.value ? Colors.white : Colors.redAccent),
                          weight: 700,
                        ),
                        iconSize: 20,
                        onPressed: () => onDeletePressed(),
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
                      decoration: InputDecoration(labelText: 'Descripción'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.palette['black'],
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
