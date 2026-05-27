## 2024-05-18 - Optimize list filtering in CustomPainter loops
**Learning:** In Flutter's CustomPainter, using O(N) operations like `.where()` list filtering inside nested rendering loops causes severe performance bottlenecks during frequent repaints.
**Action:** Always pre-group data outside the `paint` or rendering loops using a pre-allocated list of lists (for small, fixed integer ranges like astrological houses) or a Map.
