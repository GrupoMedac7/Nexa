import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nexa/views/home_page/home_page.dart';
import 'package:nexa/views/register_page/register_page.dart';
import 'firebase_options.dart';
import 'package:nexa/core/theme_provider.dart';
import 'package:nexa/services/auth_gate.dart';
import 'package:nexa/views/login_page/login_page.dart';
import 'package:nexa/views/register_page/register_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'Nexa',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(), // Ruta inicial aqui se puede poner AuthGate y te lleva al login primero
            '/home': (context) => const HomePage(), // Por si se usa también explícitamente
            '/login': (context) => const LoginPage(), // 💥 REGISTRADA AQUÍ
            '/register':(context) => const RegisterPage(),
          }
          // Pantalla inicial (puedes cambiar AuthGate por LoginPage, HomePage, etc.)
          //home: const HomePage(), //AuthGate
        );
      },
    );
  }
}
