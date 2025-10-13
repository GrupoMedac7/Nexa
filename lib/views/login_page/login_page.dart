import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/product/5uDkqTCo0ng07nLsRmx8');
          },
          child: Text('Go to product page')
        ),
      ),
    );
  }
}