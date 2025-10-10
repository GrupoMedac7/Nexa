import 'package:flutter/material.dart';
import 'package:nexa/core/theme_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onLogin() {
    // Aquí pondrás tu lógica de login más adelante
    print('Login con: ${emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppTheme.palette;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),

            // 🔵 Logo NeXa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: "Ne", style: TextStyle(color: palette["black"])),
                      TextSpan(text: "Xa", style: TextStyle(color: palette["dark_purple"])),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.person_outline),
                    const SizedBox(width: 12),
                    Switch(
                      value: AppTheme.isDarkMode.value,
                      onChanged: (value) {
                        AppTheme.isDarkMode.value = value;
                      },
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 60),

            Text(
              "Login",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: palette["dark_blue"],
              ),
            ),

            const SizedBox(height: 32),

            // 🔒 Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "email@example.com",
              ),
            ),
            const SizedBox(height: 16),

            // 🔐 Contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "••••••••",
              ),
            ),
            const SizedBox(height: 24),

            // 🔘 Botón Login
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette["dark_purple"],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 4,
                  shadowColor: Colors.grey[600],
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔗 Registro
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Aún no te has registrado? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register'); // 👈 Navega a RegisterPage
                  },
                  child: Text(
                    "Click aquí",
                    style: TextStyle(
                      color: palette["dark_purple"],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline, // opcional, queda más claro como enlace
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
