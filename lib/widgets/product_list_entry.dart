import 'package:flutter/material.dart';
import 'package:nexa/screens/product_details_page.dart';

class ProductListEntry extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String category;
  final int stock;
  final double price;

  const ProductListEntry({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.stock,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(
                id: id,
                name: name,
                description: description,
                category: category,
                stock: stock,
                price: price,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              Text(
                price.toString(),
                style: TextStyle(
                  color: Colors.green
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}