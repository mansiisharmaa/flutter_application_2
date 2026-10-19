import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/auth/login_screen.dart';
import 'package:flutter_application_2/screens/home/main_wrapper_screen.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (AuthService.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainWrapperScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.call_rounded, size: 72, color: Colors.blueAccent),
            SizedBox(height: 16),
            Text(
              'ConnectCall',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Connect with anyone, anywhere.',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
