import 'package:flutter/material.dart';

/// Step 2 of the Shuttle flow.
/// Shown right after a successful QR scan (or if the user skips scanning).
/// Lets the rider pick a source stop and a destination stop from
/// dropdown lists, then confirm to book the shuttle.
class ShuttleRouteScreen extends StatefulWidget {
  /// Raw value from the scanned QR code, if any. You can use this to
  /// pre-select the source stop or validate that the scanned shuttle
  /// serves a known route — wire that logic in initState() below.
  final String? scannedCode;

  const ShuttleRouteScreen({super.key, required this.scannedCode});

  @override
  State<ShuttleRouteScreen> createState() => _ShuttleRouteScreenState();
}

class _ShuttleRouteScreenState extends State<ShuttleRouteScreen> {
  // TODO: replace with stops loaded from your API / roster office locations.
  final List<String> _stops = const [
    'Nivaata System - Main Gate',
    'Indira Nagar Metro',
    'Domlur Signal',
    'Marathahalli Bridge',
    'Whitefield Tech Park',
    'KP Tower',
    'Sector 15',
  ];

  String? _source;
  String? _destination;

  @override
  void initState() {
    super.initState();
    // Example: if the QR code matched one of our known stops, pre-fill it.
    if (widget.scannedCode != null && _stops.contains(widget.scannedCode)) {
      _source = widget.scannedCode;
    }
  }

  bool get _canConfirm =>
      _source != null && _destination != null && _source != _destination;

  void _onConfirm() {
    if (!_canConfirm) return;

    // TODO: call your booking API here with (_source, _destination).
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shuttle booked: $_source -> $_destination')),
    );

    // Pop back to wherever this flow started (e.g. HomeScreen).
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1E6FBA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        title: const Text(
          'Book Shuttle',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.scannedCode != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.qr_code, color: primaryBlue, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Scanned: ${widget.scannedCode}',
                        style: const TextStyle(color: primaryBlue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            const Text(
              'Source',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Select source stop',
              value: _source,
              onChanged: (val) => setState(() => _source = val),
            ),

            const SizedBox(height: 24),

            const Text(
              'Destination',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Select destination stop',
              value: _destination,
              onChanged: (val) => setState(() => _destination = val),
            ),

            if (_source != null && _source == _destination) ...[
              const SizedBox(height: 8),
              const Text(
                'Source and destination cannot be the same',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canConfirm ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Confirm Shuttle',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _stops
              .map((stop) => DropdownMenuItem(value: stop, child: Text(stop)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
