import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/providers/product_provider.dart';
import 'package:nexa/views/product_page/product_page.dart';

class ProductLoader extends StatefulWidget {
  final String productId;

  const ProductLoader({
    super.key,
    required this.productId,
  });

  @override
  State<ProductLoader> createState() => _ProductLoaderState();
}

class _ProductLoaderState extends State<ProductLoader> {
  final ProductProvider provider = ProductProvider();
  ProductModel? productModel;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await provider.loadProduct(widget.productId);
    if (!mounted) return;
    if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error!)),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else if (provider.product != null) {
      setState(() {
        productModel = provider.product;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (productModel != null) {
      return ProductPage(productModel: productModel!);
    }
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
