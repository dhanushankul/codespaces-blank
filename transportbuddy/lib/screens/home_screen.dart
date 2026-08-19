import 'package:flutter/material.dart';

import 'create_roster_screen.dart';
import 'schedule_screen.dart';
import 'my_trips_screen.dart';
import 'shuttle_qr_scan_screen.dart';
import 'adhoc_booking_screen.dart';
import 'my_profile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color(0xFF1976B9);
  static const Color logoBlue = Color(0xFF174A68);
  static const Color teal = Color(0xFF18A79B);
  static const Color textDark = Color(0xFF171717);
  static const Color pageBackground = Color(0xFFF7F7F7);
  static const Color iconBackground = Color(0xFFEAF4FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------
            // TOP HEADER
            // -----------------------------------------------------------
            _buildTopHeader(),

            // -----------------------------------------------------------
            // BLUE WELCOME SECTION
            // -----------------------------------------------------------
            _buildWelcomeSection(context),

            // -----------------------------------------------------------
            // CONTENT
            // -----------------------------------------------------------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  44,
                  20,
                  20,
                ),
                children: [
                  _buildHolidayCard(),

                  const SizedBox(height: 54),

                  _buildTPinCard(),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------------------------------------------------------
      // BOTTOM NAVIGATION
      // ---------------------------------------------------------------
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // ===================================================================
  // TOP HEADER
  // ===================================================================

  Widget _buildTopHeader() {
    return Container(
      height: 104,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Hamburger
          const Icon(
            Icons.menu,
            color: primaryBlue,
            size: 44,
          ),

          const SizedBox(width: 12),

          // RouteMatic logo
          _buildRouteMaticLogo(),

          const Spacer(),

          // Support
          const Icon(
            Icons.headset_mic_outlined,
            color: primaryBlue,
            size: 42,
          ),

          const SizedBox(width: 22),

          // Notification
          const Icon(
            Icons.notifications,
            color: primaryBlue,
            size: 42,
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // ROUTEMATIC LOGO
  // ===================================================================

  Widget _buildRouteMaticLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo mark
        SizedBox(
          width: 48,
          height: 54,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 7,
                child: Container(
                  width: 28,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: teal,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 8,
                top: 2,
                child: Icon(
                  Icons.play_arrow,
                  color: logoBlue,
                  size: 46,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 2),

        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Route',
                style: TextStyle(
                  color: logoBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: 'Matic',
                style: TextStyle(
                  color: teal,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===================================================================
  // WELCOME BLUE SECTION
  // ===================================================================

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        48,
        30,
        30,
        30,
      ),
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome text
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Debendra',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 42),

          // Four quick links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickLink(
                icon: Icons.person,
                label: 'My Profile',
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyProfileScreen(),
                  ),
                );
                },
              ),

              _quickLink(
                icon: Icons.bar_chart,
                label: 'My Stats',
                onTap: () {},
              ),

              _quickLink(
                icon: Icons.badge_outlined,
                label: 'e-Pass',
                onTap: () {},
              ),

              _quickLink(
                icon: Icons.directions_car,
                label: 'My Trips',
                onTap: () {
                  // Navigate to My Trips
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyTripsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // QUICK LINK
  // ===================================================================

  Widget _quickLink({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: primaryBlue,
              size: 48,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // HOLIDAY DECLARATION CARD
  // ===================================================================

  Widget _buildHolidayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        28,
        30,
        28,
        24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF9BD8CB),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Holiday Declaration',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_up,
                  color: primaryBlue,
                  size: 27,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Description
          const Text(
            'This is to inform you in advance that our office will be '
            'closed from 1st Sep 2024 to 3rd Sep 2024. Our team will '
            'be taking this time off to spend the wonderful holiday '
            'season with their families and friends. Duri...',
            style: TextStyle(
              color: textDark,
              fontSize: 19,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          // More
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'More >>',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // T-PIN CARD
  // ===================================================================

  Widget _buildTPinCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        28,
        30,
        28,
        32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where to Find your T-PIN',
            style: TextStyle(
              color: textDark,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 22),

          Text(
            'You can view and change your T-PIN under your profile',
            style: TextStyle(
              color: textDark,
              fontSize: 19,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // BOTTOM NAVIGATION
  // ===================================================================

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        18,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bottomNavItem(
              icon: Icons.calendar_month,
              label: 'Roster',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateRosterScreen(),
                  ),
                );
              },
            ),

            _bottomNavItem(
              icon: Icons.directions_walk,
              label: 'Adhoc',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdhocBookingScreen(),
                  ),
                );
              },
            ),

            _bottomNavItem(
              icon: Icons.directions_bus,
              label: 'Bus',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScheduleScreen(),
                  ),
                );
              },
            ),

            _bottomNavItem(
              icon: Icons.airport_shuttle,
              label: 'Shuttle',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShuttleQrScanScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================================
  // BOTTOM NAV ITEM
  // ===================================================================

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE1E8ED),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: primaryBlue,
                size: 45,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF444444),
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}