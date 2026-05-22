## 2024-11-20 - Adding Tooltips to Flutter IconButtons
**Learning:** In Flutter, adding a `tooltip` property to an `IconButton` serves a dual purpose: it provides a visual hover label for desktop/web users and acts as the semantic label for screen readers (equivalent to ARIA labels in web development). This is the standard method for ensuring accessibility on icon-only interactive elements in this app.
**Action:** Always include the `tooltip` property on `IconButton` widgets if they contain only an icon, to ensure compliance with accessibility best practices.
