import 'package:flutter/material.dart';
import '../theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Privacy Policy', style: TextStyle(color: AppTheme.textMain)),
        iconTheme: const IconThemeData(color: AppTheme.textMain),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: July 31, 2026',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: 'Introduction',
              content: 'Welcome to Obsidian Astro. We respect your privacy and are committed to protecting it. This Privacy Policy explains our practices regarding your information.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Data Collection and Use',
              content: 'Obsidian Astro is designed to be privacy-conscious. We do not collect, store, or share any personal data or usage metrics from you. All app logic and calculations are performed locally on your device.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Third-Party Services (Google Ads)',
              content: 'Our app uses Google AdMob to display advertisements. Google AdMob may collect and use data as a third-party service provider. This includes device information and ad interaction data to provide relevant ads. For more information on how Google collects and uses your data, please review the Google Privacy Policy.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Changes to This Privacy Policy',
              content: 'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Contact Us',
              content: 'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
