import 'package:flutter/material.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/views/product_page/product_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductPage(productModel: ProductModel(
      id: 'id',
      name: 'name',
      description: 'description',
      category: 'category',
      brand: 'brand',
      stock: 12,
      price: 199.99,
      imageRef: 'https://picsum.photos/id/237/200/300'
    ));
  }
}