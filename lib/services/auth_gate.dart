import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexa/views/home_page/home_page.dart';
import 'package:nexa/views/login_page/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> _verifyUser(User user) async {
    try {
      await user.reload();
      await user.getIdToken(true);
      return true;
    } catch (e) {
      // If verification fails, sign out and return false
      await FirebaseAuth.instance.signOut();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Waiting for FirebaseAuth stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        // No user — go to login
        if (user == null) {
          return const LoginPage();
        }

        // Verify user is still a valid user
        return FutureBuilder<bool>(
          future: _verifyUser(user),
          builder: (context, verifySnapshot) {
            if (verifySnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (verifySnapshot.hasError || verifySnapshot.data == false) return const LoginPage();

            return const HomePage();
          },
        );
      },
    );
  }
}