## 2025-01-20 - Batch I/O for State Management Deletes
**Learning:** The previous implementation for clearing tarot history inside `SettingsScreen` queried all readings and called `deleteTarotReading` per item, triggering O(N) database operations and cascading UI rebuilds.
**Action:** When performing bulk deletions or operations, define a batch query in `DatabaseHelper` (e.g., `db.delete('table_name')`), clear the memory cache array simultaneously, and invoke `notifyListeners()` exactly once.
