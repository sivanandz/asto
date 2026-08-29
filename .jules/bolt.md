## 2024-08-29 - Avoid try-catch with firstWhere
**Learning:** Using `try-catch` for control flow around `Iterable.firstWhere` is a significant performance anti-pattern in Dart. Benchmarks show it's over 10x slower than using `.where(...).firstOrNull` when the element is not found, due to the heavy cost of exception generation and stack unwinding.
**Action:** Always prefer `.where(condition).firstOrNull` or a traditional `for` loop over catching `StateError` from `firstWhere`.
