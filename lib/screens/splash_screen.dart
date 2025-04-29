import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:event_ticket/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                  Icons.qr_code_scanner,
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimary,
                )
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 800))
                .scale(delay: const Duration(milliseconds: 400)),
            const SizedBox(height: 24),
            Text(
                  'Event Ticket Scanner',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .animate()
                .fadeIn(delay: const Duration(milliseconds: 600))
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}
