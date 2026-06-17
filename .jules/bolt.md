## 2024-05-24 - Bulk DB Operations for Better Performance
**Learning:** Iterating over items and calling provider functions that perform I/O and `notifyListeners()` on each iteration causes N+1 DB queries and unnecessary cascading UI rebuilds.
**Action:** Always prefer bulk deletion/update methods at the SQLite level (`db.delete('table_name')`) and clear state locally with a single `notifyListeners()` call.
