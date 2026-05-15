## 2024-05-24 - CustomPainter Loop Optimization
**Learning:** In Flutter's `CustomPainter`, operations like `.where()` list filtering inside nested rendering loops (e.g., iterating through astrological houses to draw planets) can cause significant O(N) performance bottlenecks because the `paint` method is called up to 60 times a second during animations or repaints.
**Action:** Always pre-group data outside the loops (e.g., using a pre-allocated `List.generate(size, (_) => [])`) for fixed integer ranges to achieve O(1) lookups during the actual rendering phase.
