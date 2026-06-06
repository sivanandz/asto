
## 2024-05-18 - Avoid O(N) list filtering in CustomPainter loops
**Learning:** In Flutter, `CustomPainter` classes (like `VedicChartPainter`) re-execute their `paint` method rapidly (up to 60fps). Using O(N) operations like `.where().toList()` inside nested rendering loops for small, fixed ranges (like 12 astrological houses) causes significant memory allocation and CPU overhead during repaints.
**Action:** Always pre-group data outside the rendering loops. For small, fixed integer ranges (like 1-12), use a pre-allocated list of lists (`List.generate(size, (_) => [])`) rather than a Map to achieve O(1) lookups with zero allocation overhead inside the loop.
