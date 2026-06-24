## 2024-05-18 - Optimize Bulk Deletions
**Learning:** Calling provider functions that perform I/O and notifyListeners() inside a loop causes O(N) database queries and cascading UI rebuilds.
**Action:** When performing bulk operations (like clearing history), execute the I/O operation as a batch, clear the local state array, and call notifyListeners() only once.
