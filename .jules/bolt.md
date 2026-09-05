## 2024-05-24 - Dart try-catch performance overhead
**Learning:** Using `try-catch` with `Iterable.firstWhere` to handle missing elements is a significant performance anti-pattern in Dart. Exception handling incurs a high overhead.
**Action:** Use `.where(...).firstOrNull` (available natively in Dart 3.0+) or a standard `for` loop instead of relying on exceptions for control flow.
