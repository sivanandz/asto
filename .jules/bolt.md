## 2024-06-25 - Bulk State Management and DB Optimization
**Learning:** Looping over database operations and `notifyListeners()` for bulk deletes (like clearing history) causes O(N) database queries and cascading UI rebuilds.
**Action:** Always use batch/bulk SQL operations (e.g., `db.delete(table_name)`) and update local state arrays directly, then call `notifyListeners()` exactly once.
