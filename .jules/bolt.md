## 2024-05-24 - Pre-grouping planets to avoid O(N) operations in CustomPainter
**Learning:** Calling `.where()` list filtering inside a Flutter `CustomPainter` rendering loop or nested inside other loops creates an O(N) operation per iteration. Since `CustomPainter.paint` repaints frequently, this creates a severe performance bottleneck.
**Action:** Always pre-group data into Maps or pre-allocated lists before entering rendering or processing loops to ensure O(1) lookups during the actual loop iteration.
