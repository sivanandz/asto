import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../providers/app_provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;

        if (user == null) {
          return const _InfoCard(
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
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
                      child: _StatItem(
                        label: 'Sun Sign',
                        value: provider.sunSign.toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'Moon Sign',
                        value: provider.moonSign.toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
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
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
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
