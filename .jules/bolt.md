## 2024-05-25 - CustomPainter rendering loop optimization
**Learning:** Found an O(N) list filtering (`.where()`) inside the nested `paint` loop of `VedicChartPainter._drawNorthIndianHouses`. Since `paint` is called frequently (e.g., during animations or repaints), doing list filtering repeatedly per grid cell causes a performance bottleneck.
**Action:** Always pre-group data outside rendering loops (using a `List<List<T>>` for fixed ranges like houses or a Map) to reduce time complexity and avoid expensive operations inside `CustomPainter` loops.
