# AGENTS.md

This file provides guidance to agents when working with code in this repository.

## Project Overview
Flutter astrology app ("Obsidian Astro") with Vedic/Western chart views and Tarot features. Uses Material 3 design with custom dark theme.

## Build Commands
- `flutter run` - Run debug build
- `flutter build apk` - Build Android release
- `flutter build ios` - Build iOS release
- `flutter pub get` - Install dependencies
- `flutter analyze` - Run linting (uses flutter_lints)

## Testing
- No test directory exists yet; create `test/` folder at root for unit tests
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run single test file

## Code Style (Project-Specific)

### Theme System
- **Always use `AppTheme` from `lib/theme.dart`** for colors - never hardcode colors
- Color constants: `AppTheme.primary`, `AppTheme.textMuted`, `AppTheme.borderColor`, etc.
- Typography via `Theme.of(context).textTheme` with GoogleFonts (Public Sans for headings, Manrope for body)

### Icons
- **Use `material_symbols_icons` package** (`Symbols.*`) not standard Material Icons
- Icon pattern: `Icon(Symbols.icon_name, weight: 400, fill: isSelected ? 1.0 : 0.0)`

### UI Patterns
- Pill-shaped borders: `BorderRadius.circular(9999)`
- Consistent spacing: horizontal 16.0, vertical 32.0 for screen padding
- Custom border color: `AppTheme.borderColor` (0xFF27272A)
- Use `SingleChildScrollView` for scrollable screens

### Imports
- Use relative imports: `import '../theme.dart';` not package imports
- Always import theme in components/screens

### Widget Structure
- All widgets use `const` constructors where possible
- Use `super.key` in all widget constructors
- StatelessWidget preferred; StatefulWidget only when needed