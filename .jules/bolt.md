## 2024-05-14 - Exception handling overhead for iteration

**Learning:** Exception handling for missing elements (`Iterable.firstWhere`) introduces massive overhead. In a synthetic test, `try-catch` with `firstWhere` took ~1760ms for 1M iterations, while `.where(...).firstOrNull` took ~60ms (and a raw `for` loop ~13ms). This anti-pattern was being used in `BirthChart.getPlanet` which is likely called frequently during chart rendering.
**Action:** Avoid `try-catch` for control flow in Dart. Use `.where().firstOrNull` (or simple `for` loops for max performance) when an element might not exist in a collection.
