## 2025-03-01 - Icon-Only Buttons Require Explicit Semantic Labels
**Learning:** Flutter's `IconButton` widget does not automatically infer an ARIA label or provide context, even for extremely common icons like `Symbols.arrow_back` or `Symbols.close`. This leads to poor accessibility for screen readers and can confuse users who rely on hover tooltips for context.
**Action:** Always provide an explicit `tooltip` property to any `IconButton` or icon-only widget to ensure it has a semantic label for assistive technologies and a visual hint for cursor-based users.
