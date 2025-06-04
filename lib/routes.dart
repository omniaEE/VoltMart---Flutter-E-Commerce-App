// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/cart_page.dart';
import 'screens/product_details_page.dart';
import 'screens/category_products_page.dart';
import 'screens/orders_page.dart';
import 'screens/splash_page.dart';
import 'constants/constants.dart';
import 'screens/profile_page.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    AppConstants.splashRoute: (context) => const SplashScreen(),
    AppConstants.homeRoute: (context) => const HomeScreen(),
    AppConstants.loginRoute: (context) => const LoginScreen(),
    AppConstants.registerRoute: (context) => const RegisterScreen(),
    AppConstants.categoryProductsRoute: (context) =>
        const CategoryProductsScreen(),
    AppConstants.profileRoute: (context) => const ProfileScreen(),
    AppConstants.productRoute: (context) => const ProductDetailsScreen(),
    AppConstants.cartRoute: (context) => const CartScreen(),
    AppConstants.ordersRoute: (context) => const OrdersScreen(),
  };
}
