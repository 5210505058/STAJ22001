import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final String qrData = "$userName - $level Üye - %$discount İndirim";
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color levelColor(String lvl) {
      switch (lvl.toLowerCase()) {
        case "bronz":
        case "bronze":
          return const Color(0xFFCD7F32);
        case "silver":
          return const Color(0xFFC0C0C0);
        case "gold":
          return const Color(0xFFFFD700);
        case "platinum":
          return const Color(0xFFE5E4E2);
        case "elmas":
        case "diamond":
          return const Color(0xFF5AC8FA);
        default:
          return theme.colorScheme.primary;
      }
    }

    final Color badgeColor = levelColor(level);

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Kodum"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF111827)]
                : [const Color(0xFFF8FAFC), const Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 8,
              shadowColor: badgeColor.withOpacity(0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Başlık + Rozet
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [badgeColor, badgeColor.withOpacity(0.55)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: badgeColor.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.workspace_premium, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName.isEmpty ? "Kullanıcı" : userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.verified, size: 18, color: badgeColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Seviye: $level  •  İndirim: %$discount",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: theme.dividerColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 18),

                    // “Cam efektli” QR kutusu
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.surface.withOpacity(isDark ? 0.25 : 0.65),
                            theme.colorScheme.surface.withOpacity(isDark ? 0.15 : 0.45),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: badgeColor.withOpacity(0.35),
                          width: 1.2,
                        ),
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        gapless: true,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        size: 230,
                      ),
                    ),

                    const SizedBox(height: 18),
                    Text(
                      "Bu kodu kasiyere göstererek indirimden yararlanabilirsin.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.75),
                      ),
                    ),

                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text("Paylaş"),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              backgroundColor: badgeColor,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () async {
                              // DÜZELTİLDİ: SharePlus.instance.share -> Share.share
                              await Share.share(qrData);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.copy),
                            label: const Text("Kopyala"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(color: badgeColor.withOpacity(0.7), width: 1.4),
                            ),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: qrData));
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("QR bilgisi kopyalandı"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: badgeColor.withOpacity(0.95),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
