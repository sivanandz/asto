import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/birth_chart.dart';
import '../models/user_profile.dart';
import '../providers/app_provider.dart';
import '../database/database_helper.dart';

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
          children: [
            // Profile Section
            _buildSectionTitle(context, 'Profile'),
            _buildProfileCard(context),
            const SizedBox(height: 32),

            // Chart Preferences
            _buildSectionTitle(context, 'Chart Preferences'),
            _buildAyanamsaSelector(context),
            const SizedBox(height: 16),
            _buildChartStyleSelector(context),
            const SizedBox(height: 32),

            // Data Management
            _buildSectionTitle(context, 'Data Management'),
            _buildDataActions(context),
            const SizedBox(height: 32),

            // About
            _buildSectionTitle(context, 'About'),
            _buildAboutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textMuted,
              letterSpacing: 1.5,
            ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        
        if (user == null) {
          return _buildInfoCard(
            context,
            icon: Symbols.person_off,
            title: 'No Profile',
            subtitle: 'Create a profile in the Onboarding tab',
          );
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, Color(0xFF083250)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.birthDate.day}/${user.birthDate.month}/${user.birthDate.year} • ${user.birthTime}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.birthLocation,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (provider.hasUser) ...[
                const SizedBox(height: 16),
                const Divider(color: AppTheme.borderColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'Sun Sign',
                        value: provider.sunSign.toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'Moon Sign',
                        value: provider.moonSign.toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        label: 'Rising',
                        value: provider.risingSign.toUpperCase(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context, {required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textMuted,
              ),
        ),
      ],
    );
  }

  Widget _buildAyanamsaSelector(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Symbols.format_align_center, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayanamsa',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Used for Vedic chart calculations',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...AyanamsaType.values.map((type) {
                return RadioListTile<AyanamsaType>(
                  title: Text(
                    _getAyanamsaName(type),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    _getAyanamsaDescription(type),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMuted,
                        ),
                  ),
                  value: type,
                  groupValue: provider.ayanamsaType,
                  onChanged: (value) {
                    if (value != null) {
                      provider.setAyanamsaType(value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_getAyanamsaName(value)} selected'),
                          backgroundColor: AppTheme.primary,
                        ),
                      );
                    }
                  },
                  activeColor: AppTheme.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getAyanamsaName(AyanamsaType type) {
    return switch (type) {
      AyanamsaType.lahiri => 'Lahiri (Chitrapaksha)',
      AyanamsaType.raman => 'Raman',
      AyanamsaType.krishnamurti => 'Krishnamurti (KP)',
    };
  }

  String _getAyanamsaDescription(AyanamsaType type) {
    return switch (type) {
      AyanamsaType.lahiri => 'Official ayanamsa of India, most widely used',
      AyanamsaType.raman => 'Based on calculations by B.V. Raman',
      AyanamsaType.krishnamurti => 'Used in KP System of astrology',
    };
  }

  Widget _buildChartStyleSelector(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Symbols.grid_view, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Vedic Chart Style',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Preferred visualization for Vedic charts',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('North Indian'),
                subtitle: const Text('Diamond-style chart'),
                trailing: provider.vedicChartStyle == VedicChartStyle.northIndian
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : const Icon(Icons.radio_button_unchecked, color: AppTheme.textMuted),
                onTap: () {
                  provider.setVedicChartStyle(VedicChartStyle.northIndian);
                },
              ),
              ListTile(
                title: const Text('South Indian'),
                subtitle: const Text('Square-style chart'),
                trailing: provider.vedicChartStyle == VedicChartStyle.southIndian
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : const Icon(Icons.radio_button_unchecked, color: AppTheme.textMuted),
                onTap: () {
                  provider.setVedicChartStyle(VedicChartStyle.southIndian);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDataActions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildActionTile(
            context,
            icon: Symbols.delete,
            title: 'Clear Tarot History',
            subtitle: 'Delete all saved readings',
            onTap: () => _showClearConfirmation(context, 'tarot'),
          ),
          const Divider(color: AppTheme.borderColor, height: 1),
          _buildActionTile(
            context,
            icon: Symbols.delete_forever,
            title: 'Delete All Data',
            subtitle: 'Remove profile, charts, and readings',
            isDestructive: true,
            onTap: () => _showClearConfirmation(context, 'all'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppTheme.error : AppTheme.textMuted),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppTheme.error : AppTheme.textMain,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
      ),
      trailing: const Icon(Symbols.chevron_right, color: AppTheme.textMuted),
      onTap: onTap,
    );
  }

  void _showClearConfirmation(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLow,
        title: Text(
          type == 'all' ? 'Delete All Data?' : 'Clear History?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          type == 'all'
              ? 'This will permanently delete your profile, all charts, and tarot readings. This action cannot be undone.'
              : 'This will delete all your saved tarot readings. This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              if (type == 'all') {
                final provider = context.read<AppProvider>();
                final user = provider.currentUser;
                if (user != null) {
                  await provider.deleteUserProfile(user.id);
                }
                await DatabaseHelper.instance.close();
                // Clear all data by reinitializing
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data deleted'),
                      backgroundColor: AppTheme.error,
                    ),
                  );
                }
              } else {
                // Clear tarot history
                final readings = context.read<AppProvider>().tarotReadings;
                for (final reading in readings) {
                  await context.read<AppProvider>().deleteTarotReading(reading.id);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tarot history cleared'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _buildInfoRow('App Version', '1.0.0'),
          const Divider(color: AppTheme.borderColor),
          _buildInfoRow('Swiss Ephemeris', 'v2.10'),
          const Divider(color: AppTheme.borderColor),
          _buildInfoRow('Database', 'SQLite'),
          const Divider(color: AppTheme.borderColor),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Privacy Policy'),
            trailing: const Icon(Symbols.open_in_new, size: 16),
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Terms of Service'),
            trailing: const Icon(Symbols.open_in_new, size: 16),
            onTap: () {
              // TODO: Open terms
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textMuted, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}