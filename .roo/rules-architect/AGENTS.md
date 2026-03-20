# AGENTS.md - Architect Mode

This file provides architecture-specific guidance for agents designing solutions in this Flutter project.

## Architecture Rules (Non-Obvious Only)

### State Management Approach
- **Current**: Simple `setState` in `MainLayout` for tab switching
- **Pattern**: `IndexedStack` preserves widget state across tab switches (prevents rebuilds)
- **Drawer**: Uses `GlobalKey<ScaffoldState>` for imperative drawer control

### Navigation Architecture
- Single `MainLayout` as shell with `IndexedStack` body
- 5 screens managed by index in `_screens` list
- No Navigator routes defined - all navigation is tab-based
- Drawer items don't navigate yet (onTap empty)

### Theme Architecture
- Single `AppTheme` class with static getters and constants
- `darkTheme` getter returns complete `ThemeData` with Material 3
- Custom colors exposed as static constants for one-off use
- Typography uses GoogleFonts with specific weights per text style

### Component Design Patterns

**TopAppBar**:
- Implements `PreferredSizeWidget` for Scaffold.appBar
- Accepts `title` and `onMenuPressed` callbacks
- Hardcoded avatar image with error fallback

**BottomNavBar**:
- Custom implementation (not using BottomNavigationBar)
- Uses `SafeArea` + `Row` of `_buildNavItem` widgets
- Selected state: filled background container + primary color

**Screen Pattern**:
- All screens are `StatelessWidget`
- Root: `SingleChildScrollView` with symmetric padding
- Content sections separated by `const SizedBox(height: 24/32/48)`

### Responsive Design
- Breakpoint at 800px (see `tarot_screen.dart` `LayoutBuilder`)
- Wide: Row layout with horizontal spacing
- Narrow: Column layout with vertical spacing
- Pattern: `isWide = constraints.maxWidth > 800`

### Future Considerations
- Chart rendering will need custom painters or flutter_svg
- Form state in OnboardingScreen not yet implemented
- No backend integration yet (all data is hardcoded/mock)
- Test directory needs to be created at project root