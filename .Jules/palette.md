## 2024-05-14 - Improve accessibility of IconButtons
**Learning:** Adding descriptive `tooltip` to `IconButton`s in Flutter improves accessibility for screen readers and provides a helpful hover state for desktop users. This is a simple and effective micro-UX enhancement that follows Material Design guidelines without altering existing components' appearance or functionality. We observed missing tooltips for 'clear search' and 'back' buttons.
**Action:** Implemented `tooltip` text for icon-only buttons to enhance accessibility in `location_search_field.dart` and `settings_screen.dart`.
