import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_logo_header.dart';
import 'home_screen.dart';

/// STEP 2a of the login flow (existing user path).
/// Email is pre-filled (read-only) from the previous screen; user types
/// their password. "Forgot Password" and "New User Sign Up" are stub links.
class SignInScreen extends StatefulWidget {
  final String email;
  const SignInScreen({super.key, required this.email});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignInPressed() {
    const String officialEmail = 'ankul.gautam@ericsson.com';
    const String officialPassword = 'project@12345';

    final enteredEmail = widget.email.trim();
    final enteredPassword = _passwordController.text;

    if (enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    // Validate email and password
    if (enteredEmail != officialEmail || enteredPassword != officialPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Login successful
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              const AppLogoHeader(),
              const SizedBox(height: 60),
              const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              // Read-only email row carried over from EmailScreen.
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.email,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Container(height: 1, color: Colors.white54),
              const SizedBox(height: 24),

              // Password field with show/hide toggle.
              Row(
                children: [
                  const Icon(Icons.lock, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ],
              ),
              Container(height: 1, color: Colors.white54),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: navigate to forgot-password flow
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSignInPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'New User Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
