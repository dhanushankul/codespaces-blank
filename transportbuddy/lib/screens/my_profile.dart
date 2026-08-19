import 'package:flutter/material.dart';

/// Shown when tapping "My Profile" on the home screen.
/// Displays the signed-in user's basic details. Right now the values are
/// hardcoded — see the TODO below for wiring it to a real user object /
/// API response instead.
class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  // TODO: replace these hardcoded values with the logged-in user's real
  // data, e.g. passed in via constructor params or read from a
  // UserProvider / auth state after sign-in.
  static const String _name = 'Ankul Gautam';
  static const String _signum = 'weghuk';
  static const String _email = 'ankul.gautam@ericssson.com';
  static const String _company = 'Ericsson';

  static const Color primaryBlue = Color(0xFF1E6FBA);
  static const Color textGrey = Color(0xFF6B6B6B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        title: const Text('My Profile', style: TextStyle(color: Colors.black87)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAvatarHeader(),
          const SizedBox(height: 24),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildAvatarHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: primaryBlue,
          child: Text(
            _initials(_name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          _name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          _company,
          style: TextStyle(color: textGrey, fontSize: 14),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.person, 'Name', _name),
          const Divider(height: 1),
          _infoRow(Icons.badge, 'Signum', _signum),
          const Divider(height: 1),
          _infoRow(Icons.email, 'Email', _email),
          const Divider(height: 1),
          _infoRow(Icons.business, 'Company', _company),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: textGrey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}