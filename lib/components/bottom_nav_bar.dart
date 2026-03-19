import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
        color: Color(0xFF09090B),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Symbols.auto_graph, 'Charts'),
              _buildNavItem(1, Symbols.style, 'Tarot'),
              _buildNavItem(2, Symbols.nights_stay, 'Insights'),
              _buildNavItem(3, Symbols.person, 'Profile', fill: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {bool fill = false}) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppTheme.primary : AppTheme.textMuted;

    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          fill: isSelected && fill ? 1.0 : 0.0,
          weight: 400,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.textMain : color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Manrope',
          ),
        ),
      ],
    );

    if (isSelected && fill) {
      child = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: child,
      );
    }

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
