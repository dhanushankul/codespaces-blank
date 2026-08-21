import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/shuttle_route_screen.dart';

class ShuttleQrScanScreen extends StatefulWidget {
  const ShuttleQrScanScreen({super.key});

  @override
  State<ShuttleQrScanScreen> createState() => _ShuttleQrScanScreenState();
}

class _ShuttleQrScanScreenState extends State<ShuttleQrScanScreen> {
  late final MobileScannerController _controller;

  bool _handled = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final String? scannedValue = barcode.rawValue;

      if (scannedValue == null || scannedValue.trim().isEmpty) {
        continue;
      }

      _handled = true;

      debugPrint('QR Code detected: $scannedValue');

      _controller.stop();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ShuttleRouteScreen(
            scannedCode: scannedValue,
          ),
        ),
      );

      return;
    }
  }

  void _skipManually() {
    _controller.stop();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ShuttleRouteScreen(
          scannedCode: null,
        ),
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

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        title: const Text(
          'Scan Shuttle QR',
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,

            builder: (context, state, child) {
              if (!state.isInitialized) {
                return const SizedBox.shrink();
              }

              return IconButton(
                icon: Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_off
                      : Icons.flash_on,
                  color: Colors.white,
                ),
                onPressed: () {
                  _controller.toggleTorch();
                },
              );
            },
          ),
        ],
      ),

      body: Stack(
        fit: StackFit.expand,

        children: [
          MobileScanner(
            controller: _controller,

            onDetect: _onDetect,

            // IMPORTANT:
            // mobile_scanner 7.4.0 takes ONLY 2 parameters here.
            errorBuilder: (context, error) {
              return _buildCameraError(error);
            },
          ),

          // QR scanning frame
          Center(
            child: IgnorePointer(
              child: Container(
                width: 250,
                height: 250,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          // Bottom text/buttons
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,

            child: SafeArea(
              child: Column(
                children: [
                  const Text(
                    'Align the QR code within the frame',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: _skipManually,

                    child: const Text(
                      'Skip and select manually',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraError(
    MobileScannerException error,
  ) {
    return Container(
      color: Colors.black,

      alignment: Alignment.center,

      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 60,
          ),

          const SizedBox(height: 20),

          const Text(
            'Camera unavailable',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            error.toString(),

            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: () async {
              try {
                await _controller.start();
              } catch (e) {
                debugPrint(
                  'Camera restart error: $e',
                );
              }
            },

            child: const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}