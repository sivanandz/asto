import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class SystemSelectionScreen extends StatelessWidget {
  const SystemSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your System',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 36, letterSpacing: -1.0),
          ),
          const SizedBox(height: 16),
          Text(
            'Precise astronomical calculations tailored to your preferred tradition. Choose a methodology to begin your journey.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 32),

          // North Indian Card
          _buildSystemCard(
            context,
            icon: Symbols.diamond,
            badgeLabel: 'Traditional Vedic',
            badgeColor: AppTheme.primary,
            title: 'North Indian (Vedic)',
            description: 'Diamond-style charts focusing on house positions. Ideal for detailed yogas and planetary aspects analysis.',
            buttonText: 'Begin Calculation',
            buttonStyle: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: AppTheme.surfaceContainerLowest),
            bgIcon: Symbols.grid_4x4,
            bgIconColor: AppTheme.textMuted.withOpacity(0.1),
          ),
          const SizedBox(height: 24),

          // Western Card
          _buildSystemCard(
            context,
            icon: Symbols.radio_button_checked,
            badgeLabel: 'Tropical',
            badgeColor: AppTheme.tertiary,
            title: 'Western',
            description: 'Circular wheel charts using the Tropical zodiac. Focused on psychological archetypes.',
            buttonText: 'Explore Wheel',
            buttonStyle: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.borderColor), foregroundColor: AppTheme.textMain),
          ),
          const SizedBox(height: 24),

          // South Indian Card
          _buildSystemCard(
            context,
            icon: Symbols.square,
            badgeLabel: 'Sidereal',
            badgeColor: AppTheme.primary,
            title: 'South Indian (Vedic)',
            description: 'Square-style charts focusing on zodiac sign fixed positions. Preferred for quick transits and dasha checking.',
            buttonText: 'Select Tradition',
            buttonStyle: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.borderColor), foregroundColor: AppTheme.textMain),
            bgIcon: Symbols.table_chart,
            bgIconColor: AppTheme.textMuted.withOpacity(0.1),
          ),
          const SizedBox(height: 24),

          // Tarot Card
          _buildSystemCard(
            context,
            icon: Symbols.style,
            badgeLabel: 'Intuitive',
            badgeColor: AppTheme.tertiary,
            title: 'Tarot Card Reading',
            description: 'Deep dive into your subconscious through the 78-card Rider-Waite or Thoth decks. Daily draws and celtic cross spreads.',
            buttonText: 'Draw Cards',
            buttonStyle: ElevatedButton.styleFrom(backgroundColor: AppTheme.tertiaryContainer, foregroundColor: AppTheme.textMain),
            buttonIcon: Symbols.arrow_forward,
            bgColor: const Color(0xFF083250).withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCard(
    BuildContext context, {
    required IconData icon,
    required String badgeLabel,
    required Color badgeColor,
    required String title,
    required String description,
    required String buttonText,
    required ButtonStyle buttonStyle,
    IconData? buttonIcon,
    IconData? bgIcon,
    Color? bgIconColor,
    Color bgColor = AppTheme.surfaceContainer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          if (bgIcon != null)
            Positioned(
              right: -32,
              bottom: -32,
              child: Icon(bgIcon, size: 200, color: bgIconColor),
            ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: badgeColor, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      badgeLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32)),
                const SizedBox(height: 16),
                Text(description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: buttonIcon != null
                      ? ElevatedButton.icon(
                          onPressed: () {},
                          style: buttonStyle,
                          icon: Icon(buttonIcon, size: 16),
                          label: Text(buttonText),
                          iconAlignment: IconAlignment.end,
                        )
                      : ElevatedButton(
                          onPressed: () {},
                          style: buttonStyle,
                          child: Text(buttonText),
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
