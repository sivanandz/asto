## 2024-05-24 - Dart Exception Handling for Control Flow
**Learning:** `try-catch` blocks for control flow, like catching errors from `Iterable.firstWhere` when an element is not found, incur significant performance overhead in Dart.
**Action:** Use `.where(...).firstOrNull` (natively available on `Iterable` in Dart 3.0+ without importing `package:collection`) instead of `try/catch` with `firstWhere`.
