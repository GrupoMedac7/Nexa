import 'package:flutter/material.dart';
import 'package:nexa/views/login_page/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 86),
              LoginForm(),
            ]
          ),
        ),
      ),
    );
  }
}