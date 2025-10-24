import 'package:flutter/material.dart';
import 'package:nexa/views/home_page/home_page.dart';
import 'package:nexa/views/login_page/login_page.dart';
import 'package:nexa/views/product_page/widgets/product_loader.dart';
import 'package:nexa/views/sign_in_page/sign_in_page.dart';

class AppRouter {
  static final Map<String, WidgetBuilder> staticRoutes = {
    '/': (context) => const HomePage(),
    '/login': (context) => const LoginPage(),
    '/signin': (context) => const SignInPage(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');

    if (staticRoutes.containsKey(uri.path)) {
      return MaterialPageRoute(
        builder: staticRoutes[uri.path]!,
        settings: settings,
      );
    }

    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'product') {
      final productId = uri.pathSegments[1];
      return MaterialPageRoute(
        builder: (_) => ProductLoader(productId: productId),
        settings: settings
      );
    }

    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('404 — Page Not Found')),
      ),
      settings: settings,
    );
  }
}
