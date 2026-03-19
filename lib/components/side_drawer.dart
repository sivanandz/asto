import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF09090B),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: AppTheme.borderColor)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBGbH5X0K6miAdgF5y1iSn-ge53Vc2YYVy9NsmmReLCwn9kA-HSpKesStzdV0X-gr0fuqoP-bIyq23vuVvD6SQvEWnpUmTQh2D9TXkBL16foE44TYWNKb7IbT_x7HpyMiG4IQpj9HgvruogGGQp0oVBN8RS-jbvW8eKjKRwz2dhD-9A-4U70uFT5zvXz_UVYfwcd8pIo-5aH41WBKQxY-qc4jDtE3iidOHSkDl6cVTkQT0jFZdqiKdvFXkibU0nCKXj-k__lg8CAT0',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Symbols.person),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Astro Seeker',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.textMain),
                      ),
                      Text(
                        'Premium Member',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, Symbols.brightness_7, 'Vedic Mode', true),
            _buildDrawerItem(context, Symbols.wb_sunny, 'Western Mode', false),
            _buildDrawerItem(context, Symbols.playing_cards, 'Tarot Deck', false),
            _buildDrawerItem(context, Symbols.settings, 'Birth Settings', false),
            const Divider(color: AppTheme.borderColor, thickness: 1),
            _buildDrawerItem(context, Symbols.logout, 'Logout', false, isError: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, bool isSelected, {bool isError = false}) {
    Color color = isSelected
        ? AppTheme.textMain
        : isError
            ? AppTheme.error
            : AppTheme.textMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9999),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontFamily: 'Public Sans', fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
