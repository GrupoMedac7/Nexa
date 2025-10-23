import 'package:flutter/material.dart';

class ProductFilter {
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final int? minStock;
  final int? maxStock;
  final String? searchQuery;
  final bool? isActive;
  final DateTimeRange? dateRange;

  const ProductFilter({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.minStock,
    this.maxStock,
    this.searchQuery,
    this.isActive,
    this.dateRange,
  });

  ProductFilter copyWith({
    String? category,
    double? minPrice,
    double? maxPrice,
    int? minStock,
    int? maxStock,
    String? searchQuery,
    bool? isActive,
    DateTimeRange? dateRange,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      searchQuery: searchQuery ?? this.searchQuery,
      isActive: isActive ?? this.isActive,
      dateRange: dateRange ?? this.dateRange,
    );
  }

  ProductFilter clearFilter() {
    return const ProductFilter();
  }

  bool get isEmpty {
    return category == null &&
        minPrice == null &&
        maxPrice == null &&
        minStock == null &&
        maxStock == null &&
        (searchQuery == null || searchQuery!.isEmpty) &&
        isActive == null &&
        dateRange == null;
  }

  bool get hasStockFilter {
    return minStock != null || maxStock != null;
  }

  bool get hasPriceFilter {
    return minPrice != null || maxPrice != null;
  }

  @override
  String toString() {
    return 'ProductFilter(category: $category, minPrice: $minPrice, maxPrice: $maxPrice, minStock: $minStock, maxStock: $maxStock, searchQuery: $searchQuery, isActive: $isActive)';
  }
}