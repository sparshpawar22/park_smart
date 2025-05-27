import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          icon: Icon(Icons.login),
          label: Text("Sign in with Google"),
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Sign-in failed")),
              );
            }
          },
        ),
      ),
    );
  }
}
