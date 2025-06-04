import 'package:flutter/material.dart';

class AppConstants {
  // Shared Preferences keys
  static const String loggedUserKey = 'loggedUser';
  static const String userTokenKey = 'userToken';

  // Route names
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String productRoute = '/product';
  static const String cartRoute = '/cart';
  static const String ordersRoute = '/orders';
  static const String splashRoute = '/splash';
  static const String profileRoute = '/profile';
  static const String categoryProductsRoute = '/category-products';

  // API
  static const String apiBaseUrl = 'https://ib.jamalmoallart.com/api';

  // Assets
  static const String defaultProfileImage = 'assets/images/default_user.png';
}

class AppColors {
  static const Color secondary = Color(0xFF9C27B0); // Deep purple
  static const Color primary = Color(0xFF0F9D58); // Volt green
  static const Color accent = Color(0xFF4285F4); // Electric blue
  static const Color background = Color(0xFFF2F2F2);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color splashBackground = Color(0xFF0F9D58); // Same as primary
}
