## 2024-03-24 - [O(N) Delete Replaced with O(1) Delete]
**Learning:** Calling a provider function that performs an I/O operation and `notifyListeners()` inside a loop causes O(N) database queries and cascading UI rebuilds.
**Action:** Always prefer batch operations for I/O and perform them before clearing local state array and triggering `notifyListeners()` only once.
