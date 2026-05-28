import 'package:flutter/material.dart';
import '../../theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
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
}
