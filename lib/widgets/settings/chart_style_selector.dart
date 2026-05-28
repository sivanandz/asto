import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../theme.dart';

class ChartStyleSelector extends StatelessWidget {
  const ChartStyleSelector({super.key});

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
            trailing: const Icon(Icons.check, color: AppTheme.primary),
            onTap: () {
              // TODO: Set preference
            },
          ),
          ListTile(
            title: const Text('South Indian'),
            subtitle: const Text('Square-style chart'),
            trailing: const Icon(Icons.radio_button_unchecked, color: AppTheme.textMuted),
            onTap: () {
              // TODO: Set preference
            },
          ),
        ],
      ),
    );
  }
}
