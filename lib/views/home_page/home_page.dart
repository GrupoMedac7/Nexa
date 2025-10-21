import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/providers/product_provider.dart';
import 'package:nexa/views/home_page/widgets/custom_search_bar.dart';
import 'package:nexa/views/home_page/widgets/custom_search_filters.dart';
import 'package:nexa/views/home_page/widgets/product_list.dart';
import 'package:nexa/widgets/top_bar.dart';

class SearchFilters {
  String? searchQuery;
  String? category;
  int? minPrice;
  int? maxPrice;
  int? minStock;
  int? maxStock;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductProvider productProvider = ProductProvider();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();
  List<DropdownMenuItem<String>> categoryItems = [];
  late SearchFilters _filters;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _filters = SearchFilters();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await productProvider.getAllproducts();
    final categories = <String>{};

    for (var product in products) {
      categories.add(product.category);
    }

    setState(() {
      categoryItems = categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList();
    });
  }

  Future<List<ProductModel>> _fetchProducts() async {
    return await productProvider.getProducts(
      searchQuery: _filters.searchQuery,
      category: _filters.category,
      minPrice: _filters.minPrice,
      maxPrice: _filters.maxPrice,
      minStock: _filters.minStock,
      maxStock: _filters.maxStock,
    );
  }

  void _onFiltersChanged() async {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomSearchBar(
                controller: _searchController,
                onChanged: (query) {
                  setState(() => _filters.searchQuery = query);
                  _onFiltersChanged();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: CustomSearchFilters(
                categories: categoryItems,
                categoryController: _categoriesController,
                minPriceController: _minPriceController,
                maxPriceController: _maxPriceController,
                minStockController: _minStockController,
                maxStockController: _maxStockController,
                onCategoryChanged: (value) {
                  setState(() => _filters.category = value);
                  _onFiltersChanged();
                },
                onPriceChanged: (min, max) {
                  setState(() {
                    _filters.minPrice = min.round();
                    _filters.maxPrice = max.round();
                  });
                  _onFiltersChanged();
                },
                onStockChanged: (min, max) {
                  setState(() {
                    _filters.minStock = min.round();
                    _filters.maxStock = max.round();
                  });
                  _onFiltersChanged();
                },
              ),
            ),
            ProductList(
              key: ValueKey(
                "${_filters.searchQuery}-${_filters.category}-"
                "${_filters.minPrice}-${_filters.maxPrice}-"
                "${_filters.minStock}-${_filters.maxStock}",
              ),
              fetchProducts: _fetchProducts,
            ),
          ],
        ),
      ),
    );
  }
}
