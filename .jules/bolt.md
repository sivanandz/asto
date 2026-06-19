## 2026-06-19 - Avoid N+1 Queries in SQLite loops
**Learning:** Looping over an array of items to delete them sequentially in SQLite creates an N+1 query problem, causing significant locking overhead and UI freezes as each row invokes a separate roundtrip and `notifyListeners()` call.
**Action:** Always implement a bulk deletion operation (e.g., `db.delete('table_name')`) on the database side and clear the UI array in one pass to avoid triggering cascading widget rebuilds.
