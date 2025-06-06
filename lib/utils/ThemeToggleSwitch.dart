import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SwitchListTile(
      title: Text(
        isDarkMode ? 'Light Mode' : 'Dark Mode',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: isDarkMode,
      onChanged: (_) => themeProvider.toggleTheme(),
      secondary: Icon(
        isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
        color: isDarkMode ? Colors.yellow[700] : Colors.blueGrey,
      ),
      activeColor: Colors.yellow[700],
      inactiveThumbColor: Colors.blueGrey, 
      activeTrackColor: Colors.yellow[200], 
      inactiveTrackColor: Colors.grey[300], 
    );
  }
}
