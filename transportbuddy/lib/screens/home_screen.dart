import 'package:flutter/material.dart';

import 'create_roster_screen.dart';
import 'schedule_screen.dart';
import 'my_trips_screen.dart';
import 'shuttle_qr_scan_screen.dart';
import 'adhoc_booking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // =====================================================================
  // COLORS
  // =====================================================================

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double horizontalPadding = _getHorizontalPadding(screenWidth);

            return Column(
              children: [
                // =========================================================
                // HEADER
                // =========================================================

                _buildTopHeader(screenWidth),

                // =========================================================
                // WELCOME BLUE SECTION
                // =========================================================
                _buildWelcomeSection(context, screenWidth),

                // =========================================================
                // MAIN CONTENT
                // =========================================================
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      24,
                    ),
                    children: [
                      _buildHolidayCard(screenWidth),

                      const SizedBox(height: 28),

                      _buildTPinCard(screenWidth),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // ================================================================
      // BOTTOM NAVIGATION
      // ================================================================
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // =====================================================================
  // RESPONSIVE PADDING
  // =====================================================================

  double _getHorizontalPadding(double width) {
    if (width <= 350) {
      return 12;
    }

    if (width <= 375) {
      return 16;
    }

    if (width <= 430) {
      return 20;
    }

    return 24;
  }

  // =====================================================================
  // TOP HEADER
  // =====================================================================

  Widget _buildTopHeader(double width) {
    final bool isSmallPhone = width <= 375;

    return Container(
      height: isSmallPhone ? 68 : 76,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 12 : 16),
      child: Row(
        children: [
          // ---------------------------------------------------------------
          // MENU
          // ---------------------------------------------------------------

          Icon(Icons.menu, color: primaryBlue, size: isSmallPhone ? 30 : 34),

          SizedBox(width: isSmallPhone ? 6 : 10),

          // ---------------------------------------------------------------
          // ROUTEMATIC LOGO
          // ---------------------------------------------------------------
          Expanded(child: _buildRouteMaticLogo()),

          SizedBox(width: isSmallPhone ? 5 : 10),

          // ---------------------------------------------------------------
          // SUPPORT
          // ---------------------------------------------------------------
          Icon(
            Icons.headset_mic_outlined,
            color: primaryBlue,
            size: isSmallPhone ? 27 : 31,
          ),

          SizedBox(width: isSmallPhone ? 9 : 16),

          // ---------------------------------------------------------------
          // NOTIFICATION
          // ---------------------------------------------------------------
          Icon(
            Icons.notifications,
            color: primaryBlue,
            size: isSmallPhone ? 27 : 31,
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // ROUTEMATIC LOGO
  // =====================================================================

  Widget _buildRouteMaticLogo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------------------------------------------------------
                // ACTUAL ROUTEMATIC LOGO
                // ---------------------------------------------------------

                Image.asset(
                  'assets/images/remove_icon.png',
                  width: 38,
                  height: 42,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 5),

                // ---------------------------------------------------------
                // ROUTEMATIC TEXT
                // ---------------------------------------------------------
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Route',
                        style: TextStyle(
                          color: logoBlue,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'Matic',
                        style: TextStyle(
                          color: teal,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  
  // =====================================================================
  // WELCOME SECTION
  // =====================================================================

  Widget _buildWelcomeSection(BuildContext context, double width) {
    final bool isSmallPhone = width <= 375;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmallPhone ? 18 : 28,
        isSmallPhone ? 22 : 28,
        isSmallPhone ? 18 : 28,
        isSmallPhone ? 24 : 30,
      ),
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // WELCOME TEXT
          // ---------------------------------------------------------------

          Text(
            'Welcome Debendra',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallPhone ? 25 : 28,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: isSmallPhone ? 28 : 38),

          // ---------------------------------------------------------------
          // QUICK LINKS
          //
          // IMPORTANT:
          // Expanded makes the four items automatically fit 360px.
          // ---------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _quickLink(
                  icon: Icons.person,
                  label: 'My Profile',
                  isSmallPhone: isSmallPhone,
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _quickLink(
                  icon: Icons.bar_chart,
                  label: 'My Stats',
                  isSmallPhone: isSmallPhone,
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _quickLink(
                  icon: Icons.badge_outlined,
                  label: 'e-Pass',
                  isSmallPhone: isSmallPhone,
                  onTap: () {},
                ),
              ),

              Expanded(
                child: _quickLink(
                  icon: Icons.directions_car,
                  label: 'My Trips',
                  isSmallPhone: isSmallPhone,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MyTripsScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // QUICK LINK
  // =====================================================================

  Widget _quickLink({
    required IconData icon,
    required String label,
    required bool isSmallPhone,
    required VoidCallback onTap,
  }) {
    final double tileSize = isSmallPhone ? 60 : 72;
    final double iconSize = isSmallPhone ? 34 : 40;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------------------------------------------------------
          // ICON TILE
          // ---------------------------------------------------------------

          Container(
            width: tileSize,
            height: tileSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallPhone ? 13 : 15),
            ),
            child: Icon(icon, color: primaryBlue, size: iconSize),
          ),

          const SizedBox(height: 7),

          // ---------------------------------------------------------------
          // LABEL
          // ---------------------------------------------------------------
          SizedBox(
            height: 20,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallPhone ? 14 : 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // HOLIDAY DECLARATION CARD
  // =====================================================================

  Widget _buildHolidayCard(double width) {
    final bool isSmallPhone = width <= 375;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmallPhone ? 18 : 24,
        isSmallPhone ? 20 : 26,
        isSmallPhone ? 18 : 24,
        isSmallPhone ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF9BD8CB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // CARD HEADER
          // ---------------------------------------------------------------

          Row(
            children: [
              Expanded(
                child: Text(
                  'Holiday Declaration',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textDark,
                    fontSize: isSmallPhone ? 19 : 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                width: isSmallPhone ? 38 : 42,
                height: isSmallPhone ? 38 : 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volume_up,
                  color: primaryBlue,
                  size: isSmallPhone ? 21 : 24,
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallPhone ? 14 : 18),

          // ---------------------------------------------------------------
          // DESCRIPTION
          // ---------------------------------------------------------------
          Text(
            'This is to inform you in advance that our office will be '
            'closed from 1st Sep 2024 to 3rd Sep 2024. Our team will '
            'be taking this time off to spend the wonderful holiday '
            'season with their families and friends. Duri...',
            maxLines: isSmallPhone ? 5 : 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textDark,
              fontSize: isSmallPhone ? 15 : 18,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 10),

          // ---------------------------------------------------------------
          // MORE BUTTON
          // ---------------------------------------------------------------
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'More >>',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: isSmallPhone ? 16 : 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // T-PIN CARD
  // =====================================================================

  Widget _buildTPinCard(double width) {
    final bool isSmallPhone = width <= 375;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isSmallPhone ? 18 : 24,
        isSmallPhone ? 20 : 26,
        isSmallPhone ? 18 : 24,
        isSmallPhone ? 24 : 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------------------
          // TITLE
          // ---------------------------------------------------------------

          Text(
            'Where to Find your T-PIN',
            style: TextStyle(
              color: textDark,
              fontSize: isSmallPhone ? 19 : 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: isSmallPhone ? 14 : 20),

          // ---------------------------------------------------------------
          // DESCRIPTION
          // ---------------------------------------------------------------
          Text(
            'You can view and change your T-PIN under your profile',
            style: TextStyle(
              color: textDark,
              fontSize: isSmallPhone ? 15 : 18,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // BOTTOM NAVIGATION
  // =====================================================================

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // -------------------------------------------------------------
            // ROSTER
            // -------------------------------------------------------------

            Expanded(
              child: _bottomNavItem(
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
            ),

            // -------------------------------------------------------------
            // ADHOC
            // -------------------------------------------------------------
            Expanded(
              child: _bottomNavItem(
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
            ),

            // -------------------------------------------------------------
            // BUS
            // -------------------------------------------------------------
            Expanded(
              child: _bottomNavItem(
                icon: Icons.directions_bus,
                label: 'Bus',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                  );
                },
              ),
            ),

            // -------------------------------------------------------------
            // SHUTTLE
            // -------------------------------------------------------------
            Expanded(
              child: _bottomNavItem(
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
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // BOTTOM NAV ITEM
  // =====================================================================

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------------------------------------------------------------
          // ICON TILE
          // ---------------------------------------------------------------

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E8ED), width: 1),
            ),
            child: Icon(icon, color: primaryBlue, size: 36),
          ),

          const SizedBox(height: 5),

          // ---------------------------------------------------------------
          // LABEL
          // ---------------------------------------------------------------
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
