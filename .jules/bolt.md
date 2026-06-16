
## 2024-06-16 - Prevent N+1 operations when clearing data
**Learning:** Deleting items individually in a loop caused an N+1 problem, triggering multiple database queries and `notifyListeners()` calls.
**Action:** Always implement batch or bulk operations (e.g., `delete('table')`) in `DatabaseHelper` and bulk updates in state management providers to execute operations in a single roundtrip.
