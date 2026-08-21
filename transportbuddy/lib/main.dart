import 'package:flutter/material.dart';
import 'screens/email_screen.dart';
import 'screens/home_screen.dart';
import './services/auth_service.dart';

void main() {
  runApp(const RouteMaticApp());
}

class RouteMaticApp extends StatelessWidget {
  const RouteMaticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteMatic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const AppEntryPoint(),
    );
  }
}

/// Decides where to land the user on every app launch:
/// - A valid session token exists (user hasn't logged out) -> HomeScreen
/// - No token / logged out -> EmailScreen (start of the login flow)
class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        // Still checking local storage — show a brief loading state
        // instead of flashing the login screen first.
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        final bool loggedIn = snapshot.data ?? false;
        return loggedIn ? const HomeScreen() : const EmailScreen();
      },
    );
  }
}