import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexa/core/theme_provider.dart';
import 'package:nexa/widgets/options_menu.dart';
import 'package:nexa/widgets/product_list_entry.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/widgets/search_text_field.dart';
import 'package:nexa/widgets/search_filters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String? filterCategory;
  double? filterMinPrice, filterMaxPrice;
  int? filterMinStock, filterMaxStock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          Builder(
            builder: (context) {
              return OptionsMenu(
                isDarkMode: AppTheme.isDarkMode.value,
                onToggleTheme: () {
                  AppTheme.isDarkMode.value = !AppTheme.isDarkMode.value;
                },
                onSignOut: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchTextField(
            onChanged: (value) => setState(() => searchQuery = value),
          ),
          FiltersForm(
            onApply: (category, minPrice, maxPrice, minStock, maxStock) {
              setState(() {
                filterCategory = category;
                filterMinPrice = minPrice;
                filterMaxPrice = maxPrice;
                filterMinStock = minStock;
                filterMaxStock = maxStock;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];
                var products = docs
                    .map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return ProductModel.fromMap(data, doc.id);
                    })
                    .whereType<ProductModel>()
                    .toList();

                // Apply search filter
                if (searchQuery.isNotEmpty) {
                  products = products
                      .where(
                        (p) =>
                            p.name.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            ) ||
                            p.description.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            ),
                      )
                      .toList();
                }

                // Apply advanced filters
                if (filterCategory != null) products = products.where((p) => p.category == filterCategory).toList();
                if (filterMinPrice != null) products = products.where((p) => p.price >= filterMinPrice!).toList();
                if (filterMaxPrice != null) products = products.where((p) => p.price <= filterMaxPrice!).toList();
                if (filterMinStock != null) products = products.where((p) => p.stock >= filterMinStock!).toList();
                if (filterMaxStock != null) products = products.where((p) => p.stock <= filterMaxStock!).toList();
                if (products.isEmpty) return const Center(child: Text('No products match your search.'));

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductListEntry(
                      id: product.id,
                      name: product.name,
                      description: product.description,
                      category: product.category,
                      stock: product.stock,
                      price: product.price,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
