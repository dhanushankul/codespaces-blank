import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_logo_header.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

/// STEP 2a of the login flow (existing user path).
///
/// Default/demo credentials:
/// Email: ankul.gautam@ericsson.com
/// Password: project@12345
///
/// NOTE:
/// This credential validation is intended for local/demo testing.
/// For production, validate credentials through your backend API.
class SignInScreen extends StatefulWidget {
  final String email;

  const SignInScreen({
    super.key,
    this.email = 'ankul.gautam@ericsson.com',
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const String _defaultEmail = 'ankul.gautam@ericsson.com';
  static const String _defaultPassword = 'project@12345';

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(
      text: widget.email.isNotEmpty ? widget.email : _defaultEmail,
    );

    _passwordController = TextEditingController(
      text: _defaultPassword,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignInPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validate empty fields.
    if (email.isEmpty) {
      _showMessage('Please enter your email');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password');
      return;
    }

    // Basic email validation.
    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Demo/local credential validation.
    await Future.delayed(const Duration(milliseconds: 500));

    final isValidCredentials =
        email.toLowerCase() == _defaultEmail.toLowerCase() &&
            password == _defaultPassword;

    if (!isValidCredentials) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage('Invalid email or password');
      return;
    }

    try {
      // Save session only after successful authentication.
      await AuthService.saveSession();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Clear login screen from navigation stack.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage('Unable to sign in. Please try again.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // App logo.
                const AppLogoHeader(),

                const SizedBox(height: 60),

                // Page title.
                const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 32),

                // ---------------------------------------------------------
                // EMAIL
                // ---------------------------------------------------------
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter email',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 1,
                  color: Colors.white54,
                ),

                const SizedBox(height: 24),

                // ---------------------------------------------------------
                // PASSWORD
                // ---------------------------------------------------------
                Row(
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _onSignInPressed(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter password',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 1,
                  color: Colors.white54,
                ),

                const SizedBox(height: 12),

                // ---------------------------------------------------------
                // FORGOT PASSWORD
                // ---------------------------------------------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO:
                      // Navigate to forgot-password screen.
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

                // ---------------------------------------------------------
                // SIGN IN BUTTON
                // ---------------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSignInPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      disabledBackgroundColor:
                          AppColors.primaryBlue.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ---------------------------------------------------------
                // NEW USER SIGN UP
                // ---------------------------------------------------------
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text(
                    'New User Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
