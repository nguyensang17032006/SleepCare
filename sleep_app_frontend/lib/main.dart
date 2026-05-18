import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SleepCare',
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
