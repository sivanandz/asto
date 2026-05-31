
## 2024-05-18 - Avoid `.where()` list filtering inside Flutter CustomPainters
**Learning:** Found a performance bottleneck specific to Flutter `CustomPainter` rendering. Using `.where().toList()` on a list of objects (like planets) inside the `paint` loop (or nested loops like drawing houses) causes an O(N*M) time complexity and massive object allocation every frame, leading to jank.
**Action:** When implementing or modifying rendering logic, ALWAYS pre-group the list items (e.g., using a Map or `List.generate`) outside the loop in a single O(N) pass, so the inner loops use O(1) lookups.
