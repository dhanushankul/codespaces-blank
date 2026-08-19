import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/shuttle_route_screen.dart';

class ShuttleQrScanScreen extends StatefulWidget {
  const ShuttleQrScanScreen({super.key});

  @override
  State<ShuttleQrScanScreen> createState() => _ShuttleQrScanScreenState();
}

class _ShuttleQrScanScreenState extends State<ShuttleQrScanScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController _controller;

  bool _handled = false;
  bool _cameraPermissionGranted = false;
  String? _cameraError;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _controller = MobileScannerController(
      autoStart: false,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );

    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      final status = await Permission.camera.request();

      if (!mounted) return;

      if (!status.isGranted) {
        setState(() {
          _cameraPermissionGranted = false;
          _cameraError = status.isPermanentlyDenied
              ? 'Camera permission is permanently denied.\nPlease enable it from App Settings.'
              : 'Camera permission is required to scan the QR code.';
        });
        return;
      }

      setState(() {
        _cameraPermissionGranted = true;
        _cameraError = null;
      });

      await _controller.start();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cameraError = 'Unable to start camera.\n\n$e';
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraPermissionGranted) return;

    if (state == AppLifecycleState.resumed) {
      _controller.start();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller.stop();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final String? scannedValue = barcode.rawValue;

      if (scannedValue == null || scannedValue.trim().isEmpty) {
        continue;
      }

      _handled = true;

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

      break;
    }
  }

  void _openSettings() {
    openAppSettings();
  }

  void _skipScanner() {
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
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
          if (_cameraPermissionGranted)
            ValueListenableBuilder<MobileScannerState>(
              valueListenable: _controller,
              builder: (context, state, child) {
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
          if (_cameraPermissionGranted && _cameraError == null)
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error, child) {
                return _buildCameraError(
                  error.toString(),
                );
              },
            )
          else if (_cameraError != null)
            _buildCameraError(_cameraError!)
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
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

          // Bottom controls
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
                    onPressed: _skipScanner,
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

  Widget _buildCameraError(String error) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 55,
          ),
          const SizedBox(height: 20),
          const Text(
            'Camera unavailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          if (_cameraError?.contains('Settings') ?? false)
            ElevatedButton(
              onPressed: _openSettings,
              child: const Text('Open App Settings'),
            )
          else
            ElevatedButton(
              onPressed: _initializeScanner,
              child: const Text('Try Again'),
            ),
        ],
      ),
    );
  }
}