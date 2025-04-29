import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  String _generateUniqueQRCode() {
    final random = Random();
    final code = List<int>.generate(10, (_) => random.nextInt(10)).join();
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final qrCode = _generateUniqueQRCode();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrCode,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            const Text('Scan this QR code to purchase your ticket'),
          ],
        ),
      ),
    );
  }
}
