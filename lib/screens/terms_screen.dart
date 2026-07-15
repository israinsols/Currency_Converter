import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'Terms of Service',
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
              title: 'Acceptance of Terms',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'By accessing or using the Currency Converter app ("the App"), you agree to be bound by these Terms of Service. If you do not agree with any part of these terms, you may not use the App.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '2',
              title: 'Description of Service',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'The App provides currency conversion using third-party exchange rate data. It allows users to convert between 113+ currencies, view historical trends, save favorite currency pairs, and access rates offline via local caching.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '3',
              title: 'Rate Accuracy Disclaimer',
              isDark: isDark,
              children: [
                _buildHighlightBox(
                  'IMPORTANT: Exchange rates displayed in the App are indicative and for informational purposes only. They are NOT guaranteed to be real-time, accurate, or suitable for financial transactions.',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Exchange rates fluctuate constantly and may be delayed by minutes or hours', isDark),
                _buildBulletPoint('The App is NOT a trading, banking, or financial tool', isDark),
                _buildBulletPoint('The App does NOT process actual money transfers or conversions', isDark),
                _buildBulletPoint('Always verify rates from an official financial institution before making financial decisions', isDark),
                _buildBulletPoint('The developer assumes no responsibility for decisions made based on displayed rates', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '4',
              title: 'User Responsibilities',
              isDark: isDark,
              children: [
                _buildBulletPoint('Use the App only for lawful and personal purposes', isDark),
                _buildBulletPoint('Do not attempt to reverse-engineer, decompile, or disassemble the App', isDark),
                _buildBulletPoint('Do not scrape, harvest, or systematically extract data from the App', isDark),
                _buildBulletPoint('Do not use the App in any way that could damage or impair its functionality', isDark),
                _buildBulletPoint('Do not misuse the App to violate any applicable laws or regulations', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '5',
              title: 'Intellectual Property',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'The App design, logo, code, and all related content are owned by AR Apps Studio and protected by copyright and intellectual property laws. Third-party exchange rate data belongs to their respective providers.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '6',
              title: 'Third-Party Services',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'The App relies on third-party services for exchange rate data:',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildServiceItem('ExchangeRate-API', 'Provides live exchange rates. Their own terms and privacy policy apply.', isDark),
                _buildServiceItem('Frankfurter API', 'Provides historical exchange rate data. Free, open-source API.', isDark),
                const SizedBox(height: 8),
                _buildBodyText(
                  'If these services change their terms, pricing, or become unavailable, the App may be affected. We are not responsible for third-party service interruptions.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '7',
              title: 'Limitation of Liability',
              isDark: isDark,
              children: [
                _buildHighlightBox(
                  'To the maximum extent permitted by law, the developer shall NOT be liable for any indirect, incidental, special, consequential, or punitive damages arising from:',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildBulletPoint('Financial losses based on exchange rate data displayed in the App', isDark),
                _buildBulletPoint('Missed transactions or opportunities due to rate inaccuracies', isDark),
                _buildBulletPoint('Decisions made based on App data', isDark),
                _buildBulletPoint('Service interruptions or data unavailability', isDark),
                _buildBulletPoint('Any unauthorized access to or alteration of your data', isDark),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '8',
              title: 'Service Availability',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'We strive to keep the App running smoothly, but we do not guarantee uninterrupted access. The App may be temporarily unavailable due to:',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildBulletPoint('Scheduled maintenance or updates', isDark),
                _buildBulletPoint('Third-party API downtime or rate limiting', isDark),
                _buildBulletPoint('Internet connectivity issues', isDark),
                _buildBulletPoint('Force majeure events beyond our control', isDark),
                const SizedBox(height: 8),
                _buildBodyText(
                  'No uptime guarantee is provided. Cached data may be available during offline periods.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '9',
              title: 'Changes to the App or Terms',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'We reserve the right to modify, suspend, or discontinue the App or any features at any time without prior notice. We may also update these Terms of Service from time to time. Significant changes will be communicated through in-app notifications or app store updates.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '10',
              title: 'Termination',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'We may terminate or restrict your access to the App at any time, without prior notice, for conduct that we determine violates these Terms or is harmful to other users, us, or third parties, or for any other reason.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '11',
              title: 'Governing Law',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'These Terms shall be governed by and construed in accordance with the laws of Pakistan, without regard to its conflict of law provisions. Any disputes shall be resolved in the courts of Pakistan.',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              number: '12',
              title: 'Contact Us',
              isDark: isDark,
              children: [
                _buildBodyText(
                  'If you have any questions about these Terms of Service, please contact us:',
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
          'Terms of Service',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last Updated: July 5, 2026',
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
        'These Terms of Service govern your use of the Currency Converter app. Please read them carefully before using the App. By using the App, you confirm that you accept these terms.',
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

  Widget _buildHighlightBox(String text, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
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
            'Use responsibly. Verify rates before financial decisions.',
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
