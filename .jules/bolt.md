## 2024-06-25 - CustomPainter rendering loop optimization
**Learning:** Avoid O(N) list filtering (`.where()`) inside `CustomPainter` rendering loops as they cause performance bottlenecks during frequent repaints.
**Action:** Always pre-group data outside the loops using a Map (`map.putIfAbsent...`) for general cases, or a pre-allocated list of lists (e.g., `List.generate(13, (_) => [])`) for small, fixed integer ranges like astrological houses.
