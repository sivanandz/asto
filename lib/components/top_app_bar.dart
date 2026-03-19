import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final String title;

  const TopAppBar({
    super.key,
    required this.onMenuPressed,
    this.title = 'Obsidian Astro',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.toUpperCase()),
      leading: IconButton(
        icon: const Icon(Symbols.menu, weight: 400),
        onPressed: onMenuPressed,
        tooltip: 'Menu',
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.borderColor),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBGbH5X0K6miAdgF5y1iSn-ge53Vc2YYVy9NsmmReLCwn9kA-HSpKesStzdV0X-gr0fuqoP-bIyq23vuVvD6SQvEWnpUmTQh2D9TXkBL16foE44TYWNKb7IbT_x7HpyMiG4IQpj9HgvruogGGQp0oVBN8RS-jbvW8eKjKRwz2dhD-9A-4U70uFT5zvXz_UVYfwcd8pIo-5aH41WBKQxY-qc4jDtE3iidOHSkDl6cVTkQT0jFZdqiKdvFXkibU0nCKXj-k__lg8CAT0',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Symbols.person),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppTheme.borderColor,
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
