## 2024-05-18 - Avoid O(N) list filtering inside Flutter CustomPainter loops
**Learning:** Flutter's `CustomPainter` classes repaint frequently. Using `List.where()` inside nested rendering loops (like a 3x3 grid) causes performance bottlenecks due to O(N) list traversals occurring on every frame.
**Action:** Always pre-group data outside the loops into a fast-lookup structure (like a `List<List<T>>` for small integer ranges such as astrological houses, or a `Map` for general cases) to ensure O(1) access during the actual paint loop.
