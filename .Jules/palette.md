## 2026-05-23 - Added Tooltips to IconButtons
**Learning:** In Flutter, adding a `tooltip` property to an `IconButton` is the standard way to provide both hover states and ARIA-equivalent accessibility labels for screen readers. It's especially crucial for icon-only buttons like 'Clear search' or 'Back' where the function might not be immediately obvious without text.
**Action:** Always ensure that icon-only buttons like `IconButton` have a `tooltip` assigned for both accessibility and visual clarity.
