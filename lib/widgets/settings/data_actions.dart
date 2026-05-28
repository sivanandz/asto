import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/app_provider.dart';
import '../../database/database_helper.dart';

class DataActions extends StatelessWidget {
  const DataActions({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          _ActionTile(
            icon: Symbols.delete,
            title: 'Clear Tarot History',
            subtitle: 'Delete all saved readings',
            onTap: () => _showClearConfirmation(context, 'tarot'),
          ),
          const Divider(color: AppTheme.borderColor, height: 1),
          _ActionTile(
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
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
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
}
