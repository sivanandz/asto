# AGENTS.md - Ask Mode

This file provides context for agents answering questions about this Flutter project.

## Project Context

### App Purpose
"Obsidian Astro" - A Flutter astrology app featuring:
- **Vedic astrology**: North/South Indian chart styles with sidereal zodiac
- **Western astrology**: Tropical zodiac circular wheel charts
- **Tarot**: Past/Present/Future card spreads

### Navigation Structure
Bottom nav has 5 tabs mapped to screens in `MainLayout`:
0. Charts (SystemSelectionScreen)
1. Western (WesternViewScreen)
2. Vedic (VedicViewScreen) 
3. Tarot (TarotScreen)
4. Profile/Onboarding (OnboardingScreen)

### Design System
- **Dark theme only**: Background 0xFF09090B, text 0xFFFAFAFA
- **Primary color**: Sage green (0xFF5A805B)
- **Typography**: Public Sans for headings (black 900 weight), Manrope for body
- **Border style**: 1px borders with 0xFF27272A color throughout

### Key Dependencies
- `google_fonts` - Custom typography (Public Sans, Manrope)
- `material_symbols_icons` - Icon system (NOT standard Material Icons)
- `flutter_svg` - For chart graphics (charts not yet implemented)

### File Organization
```
lib/
├── main.dart              # App entry + MainLayout with nav
├── theme.dart             # AppTheme class with all colors/typography
├── components/            # Reusable UI
│   ├── top_app_bar.dart   # Custom app bar with avatar
│   ├── bottom_nav_bar.dart # Custom nav with 4 items
│   └── side_drawer.dart   # Navigation drawer with user profile
└── screens/               # Feature screens
    ├── system_selection_screen.dart  # Choose Vedic/Western/Tarot
    ├── western_view_screen.dart      # Western chart view
    ├── vedic_view_screen.dart        # Vedic chart view
    ├── tarot_screen.dart             # Tarot spread UI
    └── onboarding_screen.dart        # Birth data input form
```

### Current State
- UI scaffold is complete with all screens
- Chart rendering not yet implemented (placeholder content)
- No test directory exists
- Uses flutter_lints for code analysis