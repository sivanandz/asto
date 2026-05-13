## 2024-05-18 - Added tooltips to icon-only buttons
**Learning:** Icon-only buttons like those in LocationSearchField (clear selection) and SettingsScreen (back button) lacked tooltips, which are the standard method for providing hover states and ARIA-equivalent accessibility labels for screen readers in Flutter.
**Action:** Added `tooltip` properties to all `IconButton` widgets to ensure they are accessible to screen readers and provide helpful hover text for desktop users.
