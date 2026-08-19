import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/shuttle_route_screen.dart';

/// Step 1 of the Shuttle flow.
/// Opens the camera and scans a QR code (e.g. pasted on the shuttle /
/// boarding point). Once a code is detected, it navigates straight to
/// ShuttleRouteScreen, passing along whatever the QR code contained
/// (you can use that value to pre-fill or restrict the source dropdown).
class ShuttleQrScanScreen extends StatefulWidget {
  const ShuttleQrScanScreen({super.key});

  @override
  State<ShuttleQrScanScreen> createState() => _ShuttleQrScanScreenState();
}

class _ShuttleQrScanScreenState extends State<ShuttleQrScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _handled = false; // guards against firing navigation multiple times

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return; // ignore extra frames once we've already acted
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? scannedValue = barcodes.first.rawValue;
    if (scannedValue == null) return;

    _handled = true;
    _controller.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShuttleRouteScreen(scannedCode: scannedValue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Scan Shuttle QR', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Simple viewfinder overlay so the user knows where to point.
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Align the QR code within the frame',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Lets a user skip scanning and go straight to picking
                    // source/destination manually, in case the QR is
                    // damaged or missing.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ShuttleRouteScreen(scannedCode: null),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip and select manually',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}