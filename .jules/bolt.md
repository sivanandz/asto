## 2024-05-15 - Optimize CustomPainter House Rendering Loops
**Learning:** O(N) operations like `.where()` list filtering inside a CustomPainter rendering loop cause significant performance bottlenecks due to frequent repaints, especially when iterated multiple times in nested grid layouts.
**Action:** Always pre-group data outside rendering loops using fixed-size collections (like `List.generate(13, ...)`) or HashMaps to enable O(1) lookups during `paint()` execution.
