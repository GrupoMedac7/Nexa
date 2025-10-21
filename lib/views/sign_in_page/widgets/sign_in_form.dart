import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';
import 'package:nexa/models/user_model.dart';
import 'package:nexa/providers/user_provider.dart';
import 'package:nexa/services/logger.dart';
import 'package:nexa/widgets/custom_snack_bar.dart';
import 'package:nexa/widgets/shadowed_field.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final UserProvider userProvider = UserProvider();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un correo válido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> onSignIn() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _loading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user == null) throw Exception('Error creating user');
      UserModel userModel = UserModel(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        isAdmin: false,
        createdAt: DateTime.now(),
      );
      await userProvider.createUser(userModel);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/');
    } on FirebaseAuthException catch (error, stacktrace) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Error al crear su usuario',
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18),
          Center(
            child: Text(
              'Regístrate',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 28),

          // Nombre
          ShadowedField(
            field: TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('Nombre'),
              validator: _validateName,
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 14),

          // Email
          ShadowedField(
            field: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('email@example.com'),
              validator: _validateEmail,
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 14),

          // Password
          ShadowedField(
            field: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: _inputDecoration('Contraseña').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppTheme.palette["dark_purple"],
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              validator: _validatePassword,
              style: TextStyle(color: Colors.black),
            ),
          ),

          const SizedBox(height: 22),

          // SignIn button
          _loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.palette['dark_purple'],
                  ),
                )
              : ElevatedButton(
                  onPressed: onSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.palette["dark_purple"],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Registrarse',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
