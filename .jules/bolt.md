## 2025-02-12 - Prevent O(N) Rebuilds During Bulk Operations
**Learning:** Calling provider methods that hit the DB and invoke `notifyListeners()` inside a loop causes O(N) database queries and cascading UI rebuilds.
**Action:** When clearing lists or bulk-updating data, execute a single batch DB operation, clear local state in one go, and call `notifyListeners()` once.
