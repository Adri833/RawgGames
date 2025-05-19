import 'package:flutter/material.dart';
import 'package:rawg_games_app/screens/home_screen.dart';
import 'package:rawg_games_app/theme/app_colors.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  theme: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.appBar,
      foregroundColor: AppColors.text,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.text),
      bodyMedium: TextStyle(color: AppColors.text),
      titleMedium: TextStyle(color: AppColors.subtitle),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: AppColors.subtitle),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  ),
  home: HomeScreen(),
);

  }
}
