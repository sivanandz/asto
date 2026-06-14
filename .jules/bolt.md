## 2024-05-24 - Avoid N+1 deletion loops in Settings
**Learning:** Found N+1 deletion loops in `lib/screens/settings_screen.dart` when clearing tarot history, executing an individual database delete per reading.
**Action:** Replace `for` loop iteration and individual deletions with a `deleteAllTarotReadings()` batch method on `DatabaseHelper` to improve deletion performance.
