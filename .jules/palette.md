## $(date +%Y-%m-%d) - Add Tooltips to IconButtons for Accessibility
**Learning:** Flutter's `IconButton` widget does not automatically infer a semantic label even when standard icons like `Symbols.arrow_back` or `Symbols.close` are used.
**Action:** Always provide an explicit `tooltip` property to `IconButton` to act as an ARIA label for screen readers.
