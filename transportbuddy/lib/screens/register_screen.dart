import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo_header.dart';
import 'signin_screen.dart';

/// STEP 2b of the login flow (new user path).
/// Shows the email entered previously and lets the user request an OTP.
/// In a real app, pressing "Generate OTP" would push an OTP-verification
/// screen; here we keep it simple and just show the action + navigation.
class RegisterScreen extends StatelessWidget {
  final String email;
  const RegisterScreen({super.key, required this.email});

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
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  const Icon(Icons.email, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      email,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              Container(height: 1, color: Colors.white54),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: call API to send OTP, then push an
                    // OtpVerificationScreen(email: email) here.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP sent to your email')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Generate OTP',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignInScreen(email: email),
                    ),
                  );
                },
                child: const Text(
                  'Existing user Sign in',
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
