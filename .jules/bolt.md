## 2024-03-22 - Optimize Flutter CustomPainter Rendering Loops

**Learning:** When implementing or optimizing Flutter's `CustomPainter` classes (like the Vedic/Western chart painters in this codebase), using O(N) list operations like `.where()` inside the `paint` method or rendering loops creates significant performance bottlenecks during frequent repaints. The `paint` method is called synchronously and blocks the UI thread; nested iteration multiplies this cost.

**Action:** Always pre-group nested data outside of rendering loops to avoid repeated filtering. Use a Map (`map.putIfAbsent...`) for general cases, or a pre-allocated array of lists (e.g., `List.generate(size, (_) => [])`) for small, fixed integer ranges like astrological houses (1-12) to achieve O(1) lookups during the render cycle.
