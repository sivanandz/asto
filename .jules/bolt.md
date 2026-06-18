## 2024-05-18 - Batch database deletions for better performance
**Learning:** In Flutter apps using `sqflite`, calling delete in a loop causes O(N) database queries and cascading UI rebuilds if `notifyListeners()` is called per item or when the loop triggers individual provider calls.
**Action:** Implement bulk operations (e.g., `deleteAllTarotReadings()`) in the database helper and provider to execute the deletion in a single I/O operation and call `notifyListeners()` once.
