import 'package:flutter/material.dart';
import 'screens/email_screen.dart';

void main() {
  runApp(const RouteMaticApp());
}

/// App root. The login flow always starts at EmailScreen; every other
/// screen is reached via Navigator.push from there (see each screen file
/// for its own "next step" comment).
class RouteMaticApp extends StatelessWidget {
  const RouteMaticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routematic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const EmailScreen(),
    );
  }
}
