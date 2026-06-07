## 2024-06-07 - Avoid O(N) operations in CustomPainter rendering loops
**Learning:** Using `.where()` list filtering inside a Flutter `CustomPainter` rendering loop (e.g., rendering grid cells or nested data) results in an O(N) operation per iteration. Since repaints occur frequently, this creates a codebase-specific performance bottleneck.
**Action:** Pre-group data structures into a dictionary or an array of arrays (e.g., `List.generate(13, (_) => [])` for fixed sizes like 12 houses) before entering the loop to ensure O(1) lookups during painting.
