import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// STEP 6 - Live trip tracking / "Safety" screen.
/// Shows ETA header, a map area (plug in google_maps_flutter for a real
/// map), safety action buttons (SOS / police / traffic / locate), a
/// slide-to-checkout control, and the driver info card.
class TripTrackingScreen extends StatelessWidget {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildEtaHeader(context),
            _buildTimeBar(),
            Expanded(child: _buildMapArea()),
            _buildSlideToCheckout(),
            _buildDriverCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEtaHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primaryBlue),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Reaching destination in 32 min',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBar() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('GPS Time: 15:10', style: TextStyle(color: Colors.white)),
          Text('ETA Time: 15:43', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  /// Placeholder map. Replace this Container with a real
  /// GoogleMap(...) widget from the google_maps_flutter package,
  /// and overlay the same action buttons using a Stack.
  Widget _buildMapArea() {
    return Stack(
      children: [
        Container(color: const Color(0xFFE0E5E9)),
        const Center(
          child: Icon(Icons.map, size: 64, color: Colors.black26),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _circleButton(icon: Icons.sos, color: AppColors.danger, textIcon: true),
              const SizedBox(height: 12),
              _circleButton(icon: Icons.local_police, color: Colors.white),
              const SizedBox(height: 12),
              _circleButton(icon: Icons.traffic, color: Colors.white),
              const SizedBox(height: 12),
              _circleButton(icon: Icons.my_location, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton({required IconData icon, required Color color, bool textIcon = false}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: textIcon
          ? const Center(
              child: Text('SOS',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            )
          : Icon(icon, color: AppColors.primaryBlue),
    );
  }

  Widget _buildSlideToCheckout() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.chevron_right, color: AppColors.success),
            ),
            const Expanded(
              child: Text(
                'Slide right to Check-out',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ),
      // NOTE: for a real "slide to confirm" gesture, wrap this in a
      // GestureDetector with onHorizontalDragUpdate, or use a package
      // like slide_to_act.
    );
  }

  Widget _buildDriverCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24, backgroundColor: Colors.black12),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Test1', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('MI016666(6666)', style: TextStyle(color: AppColors.textGrey)),
                    Row(
                      children: [
                        Text('Rating 4.6 '),
                        Icon(Icons.star, size: 14, color: Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
                child: const Icon(Icons.call, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.group, color: AppColors.primaryBlue),
              Icon(Icons.chat_bubble, color: AppColors.primaryBlue),
              Icon(Icons.bookmark, color: AppColors.primaryBlue),
              Icon(Icons.verified_user, color: AppColors.primaryBlue),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
