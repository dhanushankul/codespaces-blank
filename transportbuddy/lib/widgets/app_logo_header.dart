import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// The "RouteMatic - Powered by Intelligence. Driven by Care." logo block
/// that appears at the top of every auth screen (email, sign in, register).
class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: AppColors.teal, size: 56),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Route',
                    style: TextStyle(
                      color: AppColors.teal,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'Matic',
                    style: TextStyle(
                      color: AppColors.teal,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Powered by Intelligence. Driven by Care.',
          style: TextStyle(color: AppColors.teal, fontSize: 12),
        ),
      ],
    );
  }
}
