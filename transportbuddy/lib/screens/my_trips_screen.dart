import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'trip_tracking_screen.dart';

/// STEP 7 - "My Trips" screen.
/// Shows an Ongoing/Upcoming tab bar (here simplified to a single
/// "Ongoing" button) and an expandable trip card with booking details,
/// quick actions, Cancel Trip and T-Pin.
class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text('My Trips', style: TextStyle(color: AppColors.textDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('Ongoing', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          _buildTripCard(context),
        ],
      ),
    );
  }

  Widget _buildTripCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('20-Aug-2024', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Login: 02:15 PM', style: TextStyle(color: AppColors.textGrey)),
                    ],
                  ),
                  Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _DetailLine(label: 'Booking Type:', value: 'Roster'),
                      _DetailLine(label: 'ETA:', value: '02:05PM'),
                    ],
                  ),
                  const _DetailLine(label: 'Status:', value: 'Vehicle allocated'),
                  const _DetailLine(label: 'Vehicle:', value: 'MI016666 (6666)'),
                  const _DetailLine(label: 'Office Location:', value: 'Nivaata System'),
                  const _DetailLine(label: 'Sequence:', value: '1'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _actionIcon(Icons.check_circle, AppColors.success, () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const TripTrackingScreen()));
                      }),
                      const SizedBox(width: 12),
                      _actionIcon(Icons.sos, AppColors.danger, () {}),
                      const SizedBox(width: 12),
                      _actionIcon(Icons.my_location, AppColors.primaryBlue, () {}),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: call cancel-trip API
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.danger),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Cancel Trip', style: TextStyle(color: AppColors.danger)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryBlue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('T-Pin : 0000', style: TextStyle(color: AppColors.primaryBlue)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;
  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
          children: [
            TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
