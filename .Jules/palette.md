## 2026-05-08 - IconButton Tooltips
**Learning:** In Flutter, icon-only buttons (`IconButton`) lack semantic context by default. The `tooltip` property is the standard and most efficient way to provide both visual hover states (crucial for desktop/web) and ARIA-equivalent accessibility labels for screen readers.
**Action:** Always verify that every `IconButton` in a Flutter project includes a descriptive `tooltip` property, especially when used for standard navigation or clear actions.
