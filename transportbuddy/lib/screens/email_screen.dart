import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo_header.dart';
import 'signin_screen.dart';
import 'register_screen.dart';

/// STEP 1 of the login flow.
/// User enters their official email. The backend tells us whether this
/// email already has an account -> go to SignInScreen,
/// or is new -> go to RegisterScreen (OTP flow).
class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _agreedToPolicy = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid official email')),
      );
      return;
    }
    if (!_agreedToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Privacy Policy')),
      );
      return;
    }

    // TODO: Replace with a real API call that checks if the email
    // is already registered. For now we just demonstrate both paths.
    const bool isExistingUser = true; // <- flip to test Register flow

    if (isExistingUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SignInScreen(email: email),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterScreen(email: email),
        ),
      );
    }
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please Enter Your Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Email input row with icon, matches screenshot layout.
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: const InputDecoration(
                        hintText: 'Official Email ID',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                      ),
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
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Privacy policy checkbox row.
              Row(
                children: [
                  Checkbox(
                    value: _agreedToPolicy,
                    activeColor: AppColors.primaryBlue,
                    onChanged: (value) {
                      setState(() => _agreedToPolicy = value ?? false);
                    },
                  ),
                  const Expanded(
                    child: Wrap(
                      children: [
                        Text('I agree to the ', style: TextStyle(color: Colors.white)),
                        Text(
                          'Routematic Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
