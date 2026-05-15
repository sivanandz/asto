## 2024-05-15 - Flutter IconButton Accessibility
**Learning:** In Flutter, icon-only `IconButton` widgets do not provide accessible labels for screen readers by default. Relying solely on visual icons creates a barrier for visually impaired users.
**Action:** Always add a `tooltip` property to `IconButton` widgets when they do not have accompanying text. This provides both a visual hover state for mouse users and an ARIA-equivalent accessibility label for screen readers.
