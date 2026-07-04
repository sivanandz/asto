## 2026-07-04 - [Batching state and DB operations]
**Learning:** In state management, performing bulk operations (like clearing history) in a loop calling functions that run DB ops and `notifyListeners()` causes O(N) queries and cascading UI rebuilds.
**Action:** Execute bulk I/O as a single batch operation, update the local state once, and call `notifyListeners()` once to improve performance significantly.
