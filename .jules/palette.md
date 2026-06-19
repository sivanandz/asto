## $(date +%Y-%m-%d) - Accessibility labels for IconButtons
**Learning:** In Flutter, `IconButton` widgets do not automatically infer an ARIA label/semantic description for screen readers, even for standard icons like `Symbols.arrow_back` or `Symbols.close`. Without explicit `tooltip` attributes, screen readers may read them as "Button" or nothing at all, creating a poor experience for visually impaired users.
**Action:** Always provide an explicit, concise `tooltip` property to every `IconButton` widget to ensure standard accessibility compliance across the application.
