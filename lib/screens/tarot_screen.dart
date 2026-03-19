import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class TarotScreen extends StatelessWidget {
  const TarotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Symbols.stars, color: AppTheme.primary, fill: 1.0, size: 14),
                const SizedBox(width: 8),
                Text('DAILY TAROT SPREAD', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: 2.0, color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Past, Present, & Future',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 48, letterSpacing: -2.0),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Focus on a specific question or your current energy. Let the obsidian deck reveal the unseen paths before you.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted, fontSize: 18),
            ),
          ),
          const SizedBox(height: 64),

          // Cards Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final cards = [
                _buildTarotCard(context, Symbols.history, 'Past'),
                _buildTarotCard(context, Symbols.visibility, 'Present'),
                _buildTarotCard(context, Symbols.auto_awesome, 'Future'),
              ];

              if (isWide) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: cards.map((c) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: c)).toList(),
                );
              } else {
                return Column(
                  children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 32), child: c)).toList(),
                );
              }
            },
          ),

          const SizedBox(height: 64),

          // Actions
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.textMain,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                child: const Text('Draw Cards'),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textMain,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  side: const BorderSide(color: AppTheme.borderColor),
                ),
                child: const Text('Get Interpretation'),
              ),
            ],
          ),

          const SizedBox(height: 96),

          // Reading Context
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Reading Context', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24)),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final bentoItem1 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Symbols.nights_stay, color: AppTheme.tertiary),
                        const SizedBox(width: 12),
                        Text('Lunar Phase', style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Waxing Gibbous in Scorpio. Deep emotional insights are more accessible. Focus on internal transformation.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );

              final bentoItem2 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('78', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36, color: AppTheme.primary)),
                    const SizedBox(height: 4),
                    Text('CARDS IN DECK', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: -0.5)),
                  ],
                ),
              );

              final bentoItem3 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Symbols.auto_fix_high, size: 36, color: AppTheme.tertiary),
                    const SizedBox(height: 4),
                    Text('ZENITH MODE', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: -0.5)),
                  ],
                ),
              );

              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: bentoItem1),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: bentoItem2),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: bentoItem3),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    bentoItem1,
                    const SizedBox(height: 16),
                    bentoItem2,
                    const SizedBox(height: 16),
                    bentoItem3,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTarotCard(BuildContext context, IconData icon, String label) {
    return Container(
      width: 280,
      child: AspectRatio(
        aspectRatio: 2 / 3.5,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E201D), Color(0xFF0C0F0C)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.borderColor, width: 2, strokeAlign: BorderSide.strokeAlignInside),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 48, color: const Color(0xFF27272A)),
                    const SizedBox(height: 16),
                    Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
