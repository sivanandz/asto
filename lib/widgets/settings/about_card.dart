import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../theme.dart';

class AboutCard extends StatelessWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          const _InfoRow(label: 'App Version', value: '1.0.0'),
          const Divider(color: AppTheme.borderColor),
          const _InfoRow(label: 'Swiss Ephemeris', value: 'v2.10'),
          const Divider(color: AppTheme.borderColor),
          const _InfoRow(label: 'Database', value: 'SQLite'),
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
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
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
}
