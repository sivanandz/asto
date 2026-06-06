## 2024-06-03 - Avoid O(N) list filtering in CustomPainter loops
**Learning:** In Flutter `CustomPainter` instances (like VedicChartPainter), using O(N) operations such as `.where()` list filtering inside nested rendering loops (e.g. iterating over grid cells) causes unnecessary overhead during frequent repaints.
**Action:** Always pre-group data (e.g., using `List.generate()` to map planets to houses) outside rendering loops to reduce time complexity and avoid allocating temporary Iterables during high-frequency paint events.
