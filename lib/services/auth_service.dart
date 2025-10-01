  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:nexa/screens/home_screen.dart';
  import 'package:nexa/screens/login_screen.dart';

  class AuthGate extends StatelessWidget {
    const AuthGate({super.key});

    // Helper function to check if the user was logged out or deleted from Firebase but still have a valid token.
    // This could happen, for example, if the user is deleted but he or she reopens the app before the token expires.
    Future<void> _verifyUser(User user) async {
      try {
        await user.reload();
        await user.getIdToken(true);
      } catch (e) {
        await FirebaseAuth.instance.signOut();
      }
    }

    @override
    Widget build(BuildContext context) {
      // StreamBuilder listen for changes in a stream and refires the builder function each time the stream changes.
      // In this case the stream is FirebaseAuth.instance.authStateChanges, and the builder function is the one that
      // handles what to do in each case (user already logged in, user deleted or not logged in).
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Check that the user is still a valid user in Firebase. Use a FutureBuilder so the screen does not flicker
          // if the user happens to be recently deleted.
          final user = snapshot.data;
          if (user != null) {
            return FutureBuilder(
              future: _verifyUser(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError) {
                  return const LoginScreen();
                }
                return const HomeScreen();
              },
            );
          }
          // If there is no user info, show a LoginScreen
          return const LoginScreen();
        }
      );
    }
  }