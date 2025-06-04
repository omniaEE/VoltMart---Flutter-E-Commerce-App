import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/constants.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _loginFailed = false;
  String _errorMessage = 'Invalid email or password.';

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Make API call to authenticate
      final response = await http.post(
        Uri.parse(AppConstants.apiBaseUrl + '/v2/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Parse user data from API response
        final userData = jsonDecode(response.body);
        final user = User.fromJson(userData);

        // Store user data in SharedPreferences if "Remember Me" is checked
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString(
            AppConstants.loggedUserKey,
            jsonEncode(user.toJson()),
          );
        } else {
          await prefs.remove(AppConstants.loggedUserKey);
        }

        if (!mounted) return;
        // Navigate to home screen
        Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
      } else {
        // Handle API error
        setState(() {
          _loginFailed = true;
          _errorMessage =
              jsonDecode(response.body)['message'] ??
              'Invalid email or password.';
        });
      }
    } catch (e) {
      // Handle network or other errors
      setState(() {
        _loginFailed = true;
        _errorMessage = 'Failed to connect to the server. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_loginFailed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be 6+ chars';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Switch(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() => _rememberMe = val);
                    },
                    activeColor: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text('Remember Me'),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: AppColors.background),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppConstants.registerRoute);
                },
                child: const Text('Create a new account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
