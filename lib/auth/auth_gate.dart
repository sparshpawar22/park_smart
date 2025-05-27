import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screen/login_screen.dart';
import '../screen/home/home_screen.dart';
import '../screen/main_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const MainScreen(); // Signed in
        } else {
          return LoginScreen(); // Not signed in
        }
      },
    );
  }
}
