import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class QRCodePage extends StatelessWidget {
  final String userName;
  final String level;
  final int discount;

  const QRCodePage({
    super.key,
    required this.userName,
    required this.level,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    String qrData = "$userName - $level Üye - %$discount İndirim";

    return Scaffold(
      appBar: AppBar(title: const Text("QR Kodum")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Text("Seviye: $level", style: const TextStyle(fontSize: 18)),
            Text("İndirim: %$discount", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Share.share(qrData),
                  child: const Text("Paylaş"),
                ),
                ElevatedButton(
                  onPressed: () => Clipboard.setData(ClipboardData(text: qrData)),
                  child: const Text("Kopyala"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
