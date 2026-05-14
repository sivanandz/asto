## 2024-05-24 - O(1) house planet lookups in Vedic chart painter
**Learning:** Flutter's `CustomPainter` runs `paint()` very frequently. Doing O(N) list filtering (`.where().toList()`) inside rendering loops causes performance bottlenecks and unnecessary object allocations.
**Action:** When implementing or optimizing Flutter's `CustomPainter` classes, avoid O(N) operations like `.where()` list filtering inside the `paint` method or rendering loops. Always pre-group data outside the loops using Maps or pre-allocated Lists.
