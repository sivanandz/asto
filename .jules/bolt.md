## 2024-05-22 - Optimize custom painters
**Learning:** Calling `.where()` inside the render loops of `CustomPainter.paint()` is highly inefficient because painters redraw frequently on layout changes or animations. In `lib/components/vedic_chart_widget.dart`, `_drawNorthIndianHouses` re-evaluates `chart.positions.where((p) => p.house == actualHouse)` multiple times for every house during painting.
**Action:** Always pre-group planets into a list array or map by house before iterating through house cells to minimize O(N) operations.
