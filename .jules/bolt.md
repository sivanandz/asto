## 2024-05-14 - Use Provider State for Global UI Settings
**Learning:** Persisting UI style choices (like Vedic Chart style) directly in individual screen state causes state desynchronization and makes the experience feel broken to users since settings aren't remembered.
**Action:** Always hoist global configurations and user preferences out of individual `StatefulWidget` states and into global app providers, backed by `shared_preferences`.
