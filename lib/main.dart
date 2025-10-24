<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nexa/core/themes.dart';
import 'package:nexa/providers/product_provider.dart';
import 'package:nexa/providers/user_provider.dart';
import 'package:nexa/services/auth_gate.dart';
import 'package:nexa/services/router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/products_page.dart';
>>>>>>> FA001

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.isDarkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'Nexa',
          home: AuthGate(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
=======
    return MaterialApp(
      title: 'Nexa - Filtros Avanzados',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProductsPage(),
      debugShowCheckedModeBanner: false,
>>>>>>> FA001
    );
  }
}
