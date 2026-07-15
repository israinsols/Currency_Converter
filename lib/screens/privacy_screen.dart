import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          'Privacy Policy',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 24),
            _buildIntro(isDark),
            const SizedBox(height: 24),
            _buildSection(
              number: '1',
              title: 'Information We Collect',
              isDark: isDark,
              children: [
                _buildSubSection('Currency Preferences', 'We store your selected currencies (from/to) and favorites locally on your device. This data never leaves your device.', isDark),
                _buildSubSection('Exchange Rate Data', 'We fetch live exchange rates from ExchangeRate-API and historical data from Frankfurter API. These are cached locally for offline use. No personal data is sent to these services.', isDark),
                _buildSubSection('Device Information', 'If analytics are enabled, we may collect device model, OS version, and app version for crash reporting and performance monitoring.', isDark),
                _buildSubSection('Usage Analytics', 'Optional anonymous analytics may track screen visits and feature usage to improve the app experience.', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '2',
              title: 'How We Use Your Data',
              isDark: isDark,
              children: [
                _buildBulletPoint('Remember your last used currencies for quick access', isDark),
                _buildBulletPoint('Cache exchange rates for offline functionality', isDark),
                _buildBulletPoint('Improve app performance through crash reports (if enabled)', isDark),
                _buildBulletPoint('Understand usage patterns to enhance user experience (if analytics enabled)', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '3',
              title: 'Third-Party Services',
              isDark: isDark,
              children: [
                _buildServiceItem('ExchangeRate-API', 'Provides live currency exchange rates. Their privacy policy governs data sent during rate fetching.', isDark),
                _buildServiceItem('Frankfurter API', 'Provides historical exchange rate data. Free, open-source API with no personal data collection.', isDark),
                _buildServiceItem('Firebase Analytics (Optional)', 'Anonymous usage analytics. No personal identifiable information is collected. See Firebase privacy policy.', isDark),
                _buildServiceItem('Firebase Crashlytics (Optional)', 'Crash reporting. Collects stack traces and device info only when crashes occur.', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '4',
              title: 'Data Storage',
              isDark: isDark,
              children: [
                _buildBulletPoint('All currency preferences and favorites are stored locally on your device using Hive and SharedPreferences', isDark),
                _buildBulletPoint('Exchange rates are cached locally for offline access', isDark),
                _buildBulletPoint('No personal data is synced to cloud servers', isDark),
                _buildBulletPoint('All data is deleted when you uninstall the app', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '5',
              title: 'Permissions Used',
              isDark: isDark,
              children: [
                _buildPermissionItem('Internet Access', 'Required to fetch live exchange rates from API servers.', isDark),
                _buildPermissionItem('Storage (Optional)', 'Used to cache exchange rates locally for offline access.', isDark),
                _buildPermissionItem('Notifications (Future)', 'Will be used for rate alerts when the feature is added. You can opt-out at any time.', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '6',
              title: 'Data Sharing',
              isDark: isDark,
              children: [
                _buildHighlightBox(
                  'We do NOT sell, trade, or rent your personal data to any third parties.',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Anonymous analytics data may be shared with analytics providers (if enabled)', isDark),
                _buildBulletPoint('We may disclose data only if required by law or to protect our rights', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '7',
              title: 'Your Rights',
              isDark: isDark,
              children: [
                _buildBulletPoint('Clear all app data anytime from your device settings', isDark),
                _buildBulletPoint('Disable analytics and crash reporting in the app settings', isDark),
                _buildBulletPoint('Opt out of notifications (when rate alerts are available)', isDark),
                _buildBulletPoint('Request information about data we hold about you', isDark),
                _buildBulletPoint('Request deletion of any data we may hold', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '8',
              title: "Children's Privacy",
              isDark: isDark,
              children: [
                _buildBodyText(
                  'Our app is not directed at children under the age of 13. We do not knowingly collect personal information from children. If you are a parent or guardian and believe your child has provided us with personal information, please contact us immediately.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '9',
              title: 'Changes to This Policy',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page with an updated "Last Updated" date. You are advised to review this page periodically for any changes.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '10',
              title: 'Contact Us',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'If you have any questions or suggestions about this Privacy Policy, do not hesitate to contact us:',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildContactButton('arappsstudio10@gmail.com', isDark),
              ],
            ),
            const SizedBox(height: 40),
            _buildFooter(isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy Policy',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last Updated: January 5, 2026',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildIntro(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.limeGreen : AppColors.tealDark).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? AppColors.limeGreen : AppColors.tealDark).withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        'Currency Converter is designed with your privacy in mind. We collect minimal data, and most of it stays on your device. This policy explains what we collect, how we use it, and your rights.',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSection({required String number, required String title, required bool isDark, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDark ? AppColors.limeGreen : AppColors.tealDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }

  Widget _buildSubSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyText(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        height: 1.6,
      ),
    );
  }

  Widget _buildBulletPoint(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.limeGreen : AppColors.tealDark,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String name, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(String permission, String description, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 18,
            color: isDark ? AppColors.limeGreen : AppColors.tealDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permission,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightBox(String text, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.limeGreen : AppColors.tealDark).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.limeGreen : AppColors.tealDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_rounded,
            color: isDark ? AppColors.limeGreen : AppColors.tealDark,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String email, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse('mailto:$email');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.email_outlined,
              size: 18,
              color: isDark ? AppColors.limeGreen : AppColors.tealDark,
            ),
            const SizedBox(width: 8),
            Text(
              email,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.limeGreen : AppColors.tealDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Center(
      child: Column(
        children: [
          Text(
            'Currency Converter',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your privacy matters to us.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
