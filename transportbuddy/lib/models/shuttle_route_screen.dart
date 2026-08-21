import 'package:flutter/material.dart';

/// Step 2 of the Shuttle flow.
///
/// Shown right after a successful QR scan (or if the user skips scanning).
/// Lets the rider pick a source stop and a destination stop from
/// dropdown lists, then continue to book the shuttle.
class ShuttleRouteScreen extends StatefulWidget {
  /// Raw value from the scanned QR code, if any.
  final String? scannedCode;

  const ShuttleRouteScreen({
    super.key,
    required this.scannedCode,
  });

  @override
  State<ShuttleRouteScreen> createState() => _ShuttleRouteScreenState();
}

class _ShuttleRouteScreenState extends State<ShuttleRouteScreen> {
  final List<String> _stops = const [
    'Nivaata System - Main Gate',
    'Indira Nagar Metro',
    'Noida Metro Station Sector 15',
    'Domlur Signal',
    'Marathahalli Bridge',
    'Whitefield Tech Park',
    'KP Tower',
    'Bagmane Tech Park',
    'Manyata Embassy Business Park',
    'Ashok Nagar Metro Station',
    'Hebbal Flyover',
    'Yelahanka Satellite Town',
    'Bellandur Lake',
    'Sarjapur Road Junction',
    'Electronic City Phase 1',
    'Electronic City Phase 2',
    'HSR Layout',
    'Koramangala 5th Block',
    'Koramangala 7th Block',
  ];

  String? _source;
  String? _destination;

  @override
  void initState() {
    super.initState();

    // If the scanned QR value matches a known stop,
    // automatically select it as the source.
    if (widget.scannedCode != null &&
        _stops.contains(widget.scannedCode)) {
      _source = widget.scannedCode;
    }
  }

  bool get _canConfirm =>
      _source != null &&
      _destination != null &&
      _source != _destination;

  void _onConfirm() {
    if (!_canConfirm) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Shuttle booked: $_source -> $_destination',
        ),
      ),
    );

    // Return to the beginning of the shuttle flow.
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1E6FBA);

    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------------------------------------------------------
      // APP BAR
      // ---------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: primaryBlue,
        ),
        title: const Text(
          'Book Shuttle',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------------------------------------------------------
      // BODY
      // ---------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------
              // SCANNED QR CODE
              // ---------------------------------------------------------
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
                      const Icon(
                        Icons.qr_code,
                        color: primaryBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Scanned: ${widget.scannedCode}',
                          style: const TextStyle(
                            color: primaryBlue,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ---------------------------------------------------------
              // SOURCE
              // ---------------------------------------------------------
              const Text(
                'Source',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              _buildDropdown(
                hint: 'Select source stop',
                value: _source,
                onChanged: (value) {
                  setState(() {
                    _source = value;
                  });
                },
              ),

              const SizedBox(height: 24),

              // ---------------------------------------------------------
              // DESTINATION
              // ---------------------------------------------------------
              const Text(
                'Destination',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              _buildDropdown(
                hint: 'Select destination stop',
                value: _destination,
                onChanged: (value) {
                  setState(() {
                    _destination = value;
                  });
                },
              ),

              // ---------------------------------------------------------
              // SAME SOURCE / DESTINATION ERROR
              // ---------------------------------------------------------
              if (_source != null &&
                  _source == _destination) ...[
                const SizedBox(height: 8),
                const Text(
                  'Source and destination cannot be the same',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                  ),
                ),
              ],

              // ---------------------------------------------------------
              // CIRCULAR NEXT BUTTON
              // ---------------------------------------------------------
              const SizedBox(height: 32),

              Center(
                child: GestureDetector(
                  onTap: _canConfirm ? _onConfirm : null,
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _canConfirm
                          ? primaryBlue
                          : Colors.grey.shade300,
                      boxShadow: _canConfirm
                          ? [
                              BoxShadow(
                                color: primaryBlue.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // DROPDOWN
  // -------------------------------------------------------------------
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey,
          ),
          items: _stops.map(
            (stop) {
              return DropdownMenuItem<String>(
                value: stop,
                child: Text(
                  stop,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}