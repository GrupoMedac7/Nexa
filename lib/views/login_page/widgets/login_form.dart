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
  bool _obscurePassword = true;

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: AppTheme.palette["light_purple"],
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey),
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(
      minWidth: 48,
      minHeight: 48,
    ),
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

  void _showForgotPasswordDialog() {
    final TextEditingController emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Recuperar contraseña",
            style: TextStyle(
              color: AppTheme.palette["dark_blue"],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ingresa tu email y te enviaremos un enlace para restablecer tu contraseña.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "email@example.com",
                    filled: true,
                    fillColor: AppTheme.palette["light_purple"],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _sendPasswordResetEmail(emailController.text.trim());
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.palette["dark_purple"],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Enviar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      CustomSnackBar.show(
        context,
        'Por favor ingresa tu email',
        mode: CustomSnackBarMode.err,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        'Email de recuperación enviado. Revisa tu bandeja de entrada.',
        mode: CustomSnackBarMode.succ,
      );
    } on FirebaseAuthException catch (error, stacktrace) {
      if (!mounted) return;
      String message = 'Error al enviar el email';
      switch (error.code) {
        case 'user-not-found':
          message = 'No existe una cuenta con este email';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos. Intenta más tarde';
          break;
      }
      CustomSnackBar.show(
        context,
        message,
        mode: CustomSnackBarMode.err,
      );
      Logger.error(error.code, stacktrace);
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_obscurePassword)
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5),
                  child: Text(
                    "Contraseña visible",
                    style: TextStyle(
                      color: AppTheme.palette["dark_purple"],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .08),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: _obscurePassword ? "••••••••" : "Ingresa tu contraseña",
                        filled: true,
                        fillColor: AppTheme.palette["light_purple"],
                        contentPadding: const EdgeInsets.only(left: 20, right: 60, top: 18, bottom: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _obscurePassword ? Colors.grey.withOpacity(0.1) : AppTheme.palette["dark_purple"]?.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: _obscurePassword ? Colors.grey[600] : AppTheme.palette["dark_purple"],
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        tooltip: _obscurePassword ? "Mostrar contraseña" : "Ocultar contraseña",
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

          // ¿Has olvidado tu contraseña?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              child: Text(
                "¿Has olvidado tu contraseña?",
                style: TextStyle(
                  color: AppTheme.palette["dark_purple"],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

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
