import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAppIcon(isDark),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version ${AppConstants.appVersion}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoSection(
              title: 'Developer',
              content: 'AR Apps Studio',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _buildInfoSection(
              title: 'Contact',
              content: 'arappsstudio10@gmail.com',
              isDark: isDark,
              onTap: () => _launchEmail('arappsstudio10@gmail.com'),
            ),
            const SizedBox(height: 12),
            _buildInfoSection(
              title: 'Description',
              content: 'Real-time currency converter with offline support, historical charts, and 113+ currencies. Powered by ExchangeRate-API and Frankfurter API.',
              isDark: isDark,
            ),
            const SizedBox(height: 32),
            _buildLinkItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              isDark: isDark,
              onTap: () => Navigator.pushNamed(context, '/privacy'),
            ),
            const SizedBox(height: 10),
            _buildLinkItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              isDark: isDark,
              onTap: () => Navigator.pushNamed(context, '/terms'),
            ),
            const SizedBox(height: 10),
            _buildLinkItem(
              icon: Icons.star_outline_rounded,
              title: 'Rate Us',
              isDark: isDark,
              onTap: () => _launchUrl('https://play.google.com/store/apps/details?id=com.example.currencyconverter'),
            ),
            const SizedBox(height: 10),
            _buildLinkItem(
              icon: Icons.share_outlined,
              title: 'Share App',
              isDark: isDark,
              onTap: () => _shareApp(),
            ),
            const SizedBox(height: 40),
            // Text(
            //   'Made with Flutter',
            //   style: GoogleFonts.inter(
            //     fontSize: 12,
            //     color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon(bool isDark) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 0.5,
        ),
      ),
      child: Icon(
        Icons.currency_exchange_rounded,
        size: 40,
        color: isDark ? AppColors.limeGreen : AppColors.tealDark,
      ),
    );
  }

  Widget _buildInfoSection({required String title, required String content, required bool isDark, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              content,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: onTap != null
                    ? (isDark ? AppColors.limeGreen : AppColors.tealDark)
                    : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem({required IconData icon, required String title, required bool isDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _shareApp() {
    Share.share(
      'Check out ${AppConstants.appName} - Real-time currency converter with 113+ currencies!\nhttps://play.google.com/store/apps/details?id=com.example.currencyconverter',
    );
  }
}
