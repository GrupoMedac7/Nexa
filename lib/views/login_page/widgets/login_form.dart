import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexa/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:nexa/services/logger.dart';
import 'package:nexa/widgets/custom_snack_bar.dart';
import 'package:nexa/widgets/shadowed_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppTheme.palette["light_purple"],
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey),
  );

  void onLogin() async {
    setState(() {
      _loading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/');
    } on FirebaseAuthException catch (error, stacktrace) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Error de autentificación',
        mode: CustomSnackBarMode.err,
      );
      Logger.error(error.code, stacktrace);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Login",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.palette["dark_blue"],
            ),
          ),

          const SizedBox(height: 32),

          // Email
          ShadowedField(
            field: TextFormField(
              controller: _emailController,
              decoration: _inputDecoration("email@example.com"),
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 16),

          // Contraseña
          ShadowedField(
            field: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration("••••••••"),
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 24),

          // Botón Login
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.palette['dark_purple'],
                    ),
                  )
                : ElevatedButton(
                    onPressed: onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.palette["dark_purple"],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                      shadowColor: Colors.grey[600],
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 16)),
                  ),
          ),
          const SizedBox(height: 16),

          // Registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("¿Aún no te has registrado? "),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                child: Text(
                  "Click aquí",
                  style: TextStyle(
                    color: AppTheme.palette["dark_purple"],
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
