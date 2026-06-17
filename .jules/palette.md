## 2024-06-14 - IconButton Semantic Labels
**Learning:** In Flutter, `IconButton` widgets do not automatically infer a semantic label (even for standard icons like `Symbols.arrow_back`). An explicit `tooltip` property must be provided to act as an ARIA label for screen readers.
**Action:** Always add the `tooltip` property with a descriptive label when using an `IconButton` that does not have visible accompanying text.
