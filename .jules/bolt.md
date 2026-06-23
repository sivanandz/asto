## 2024-06-23 - Bulk State Operations Performance
**Learning:** Calling provider functions that perform I/O and `notifyListeners()` inside a loop causes O(N) database queries and cascading UI rebuilds.
**Action:** Execute the I/O operation as a single batch or query, clear the local state array, and call `notifyListeners()` only once.
