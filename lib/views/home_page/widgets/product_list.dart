import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/views/home_page/widgets/product_card.dart';

class ProductList extends StatefulWidget {
  final Future<List<ProductModel>> Function() fetchProducts;

  const ProductList({super.key, required this.fetchProducts});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scrollController = ScrollController();
  final List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

    Future<void> _loadProducts() async {
    final fetched = await widget.fetchProducts();
    setState(() {
      _products.clear();
      _products.addAll(fetched);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_products.isEmpty && _isLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.55,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ProductCard(productModel: _products[index]),
          childCount: _products.length,
        ),
      ),
    );
  }
}
