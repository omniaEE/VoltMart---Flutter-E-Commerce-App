import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    try {
      print('Starting navigation delay');
      await Future.delayed(const Duration(seconds: 2));
      print('Delay completed');

      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(AppConstants.loggedUserKey);
      final isLoggedIn = userJson != null && userJson.isNotEmpty;
      print('isLoggedIn: $isLoggedIn, userJson: $userJson');

      if (!mounted) {
        print('Widget not mounted, skipping navigation');
        return;
      }

      final destination = isLoggedIn
          ? AppConstants.homeRoute
          : AppConstants.loginRoute;
      print('Navigating to: $destination');
      Navigator.pushReplacementNamed(context, destination);
      print('Navigation executed');
    } catch (e) {
      print('Navigation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.electric_bolt, color: Colors.white, size: 80),
            const SizedBox(height: 16),
            Text(
              'VoltMart',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
