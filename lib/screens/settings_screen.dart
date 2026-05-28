import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/settings/about_card.dart';
import '../widgets/settings/ayanamsa_selector.dart';
import '../widgets/settings/chart_style_selector.dart';
import '../widgets/settings/data_actions.dart';
import '../widgets/settings/profile_card.dart';
import '../widgets/settings/section_title.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('SETTINGS'),
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Profile Section
            SectionTitle('Profile'),
            ProfileCard(),
            SizedBox(height: 32),

            // Chart Preferences
            SectionTitle('Chart Preferences'),
            AyanamsaSelector(),
            SizedBox(height: 16),
            ChartStyleSelector(),
            SizedBox(height: 32),

            // Data Management
            SectionTitle('Data Management'),
            DataActions(),
            SizedBox(height: 32),

            // About
            SectionTitle('About'),
            AboutCard(),
          ],
        ),
      ),
    );
  }
}
