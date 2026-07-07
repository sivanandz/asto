## 2024-05-18 - [Accessibility tooltips on IconButtons]
**Learning:** [In Flutter, IconButtons without explicit `tooltip` attributes are inaccessible to screen readers, similarly to missing ARIA labels in web development. Added them to improve accessibility.]
**Action:** [Always specify the `tooltip` parameter for `IconButton` widgets if they contain an icon without text to act as a semantic ARIA label for screen readers.]
