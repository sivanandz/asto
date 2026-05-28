import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../theme.dart';
import '../../models/birth_chart.dart';

class AyanamsaSelector extends StatelessWidget {
  const AyanamsaSelector({super.key});

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
              groupValue: AyanamsaType.lahiri, // Default, should come from settings
              onChanged: (value) {
                // TODO: Save preference
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${_getAyanamsaName(value!)} selected'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
              },
              activeColor: AppTheme.primary,
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }),
        ],
      ),
    );
  }
}
