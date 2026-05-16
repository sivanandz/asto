## 2024-05-18 - Added Tooltips to Icon-Only Buttons
**Learning:** Icon-only buttons (like `IconButton`) lack text labels, making them inaccessible to screen readers and difficult for users to understand their function without hover tooltips. In Flutter, the `tooltip` property provides both a visual hover state and an ARIA-equivalent label for accessibility.
**Action:** Always add a descriptive `tooltip` property to `IconButton` widgets or other icon-only interactive elements to ensure they are accessible and user-friendly.
