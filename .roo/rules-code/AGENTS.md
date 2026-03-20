# AGENTS.md - Code Mode

This file provides coding-specific guidance for agents working in this Flutter project.

## Code Mode Rules (Non-Obvious Only)

### Theme System
- **Always use `AppTheme` from `lib/theme.dart`** for colors - never hardcode colors
- Color constants available: `AppTheme.primary` (0xFF5A805B), `AppTheme.textMuted` (0xFFA1A1AA), `AppTheme.borderColor` (0xFF27272A), etc.
- Typography via `Theme.of(context).textTheme` with GoogleFonts - Public Sans for headings (display/title), Manrope for body text

### Icons (Critical)
- **Use `material_symbols_icons` package** (`Symbols.icon_name`) - NOT standard Material Icons (`Icons.icon_name`)
- Icon pattern: `Icon(Symbols.icon_name, weight: 400, fill: isSelected ? 1.0 : 0.0)`
- Common icons used: `Symbols.menu`, `Symbols.auto_graph`, `Symbols.style`, `Symbols.nights_stay`, `Symbols.person`, `Symbols.stars`, `Symbols.history`, `Symbols.visibility`

### UI Patterns
- Pill-shaped borders: `BorderRadius.circular(9999)` (used for buttons, inputs, badges)
- Screen padding: `EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0)`
- Card padding: `EdgeInsets.all(24)` or `EdgeInsets.symmetric(horizontal: 16, vertical: 4)` for badges
- Border color: Always use `AppTheme.borderColor` (0xFF27272A)

### Imports
- Use relative imports: `import '../theme.dart';` NOT package imports like `import 'package:my_app/theme.dart';`
- Every component/screen MUST import theme: `import '../theme.dart';`

### Widget Structure
- All widgets use `const` constructors where possible
- Use `super.key` in all widget constructors
- StatelessWidget preferred; StatefulWidget only when state management is required
- Custom AppBar: `TopAppBar` component implements `PreferredSizeWidget`

### Screen Structure
- All screens use `SingleChildScrollView` as root for scrollable content
- Screens are StatelessWidget unless they need local state
- Screens use consistent pattern: padding, header text, content sections