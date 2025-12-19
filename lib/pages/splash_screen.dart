import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay just for splash feel
    Timer(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ✅ User already logged in
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // ❌ Not logged in
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.inversePrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 80,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(height: 16),
            Text(
              'A.Reader',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Read • Save • Remember',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(
              color: theme.colorScheme.onPrimary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
