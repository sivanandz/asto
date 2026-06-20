## 2024-06-20 - N+1 Performance Issue in SQLite operations
**Learning:** Performing bulk operations (like clearing history) by looping through an array and calling an asynchronous provider function that performs a database operation and calls `notifyListeners()` creates an N+1 database querying problem and causes cascading UI rebuilds.
**Action:** Execute the bulk operation as a single SQL query (`delete('table_name')`), clear the local array in memory, and call `notifyListeners()` only once.
