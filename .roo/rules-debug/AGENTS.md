# AGENTS.md - Debug Mode

This file provides debugging-specific guidance for agents working in this Flutter project.

## Debug Mode Rules (Non-Obvious Only)

### Common Issues

**Missing theme import:**
- Error: `Undefined name 'AppTheme'`
- Fix: Add `import '../theme.dart';` at top of file

**Wrong icon package:**
- Error: `Undefined name 'Icons'` or wrong icon appearance
- Fix: Use `material_symbols_icons` - `import 'package:material_symbols_icons/symbols.dart';` and use `Symbols.icon_name`

**Hardcoded colors:**
- If colors don't match dark theme, check for hardcoded `Color(0xFF...)` instead of `AppTheme` constants

### Debugging Commands
```bash
# Hot reload during development
flutter run

# Check for lint issues
flutter analyze

# Verbose build output
flutter build apk --verbose
```

### Network Image Fallbacks
- Avatar images in `TopAppBar` and `SideDrawer` use `errorBuilder` for fallback icons
- If images fail to load, check network connectivity or replace with `Symbols.person`

### Layout Debugging
- Use `LayoutBuilder` for responsive layouts (see `tarot_screen.dart` for wide/narrow breakpoints at 800px)
- Check `SingleChildScrollView` usage - all screens need scrollable content

### State Management
- `MainLayout` uses `IndexedStack` to preserve state across tab switches
- Tab state managed in `_MainLayoutState` with `_currentIndex`
- Drawer uses `GlobalKey<ScaffoldState>` for programmatic opening