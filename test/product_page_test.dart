import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:nexa/models/product_model.dart';
import 'package:nexa/views/product_page/product_page.dart';

void main() {
  testWidgets('ProductPage displays data, toggles edit mode, updates product and deletes it', (
    tester,
  ) async {
    final firestore = FakeFirebaseFirestore();

    final product = ProductModel(
      id: 'p1',
      name: 'Test Product',
      brand: 'BrandX',
      category: 'Gadgets',
      price: 10.5,
      stock: 5,
      description: 'Description',
      imageRef: '',
    );

    await firestore.collection('products').doc(product.id).set(product.toMap());

    await tester.pumpWidget(
      MaterialApp(home: ProductPage(productModel: product, firestore: firestore,)),
    );

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('BrandX'), findsOneWidget);
    expect(find.text('Gadgets'), findsOneWidget);
    expect(find.text('10.50€'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    expect(find.byType(TextField), findsWidgets);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Updated Product');

    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    final updated = await firestore
        .collection('products')
        .doc(product.id)
        .get();
    expect(updated['name'], 'Updated Product');

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pump();

    final deleted = await firestore
        .collection('products')
        .doc(product.id)
        .get();
    expect(deleted.exists, isFalse);
  });
}
