## 2024-05-24 - Avoid try-catch for Iterable control flow
**Learning:** The codebase was using `try-catch` blocks around `Iterable.firstWhere` to handle cases where an element is not found. Exception handling in Dart incurs significant performance overhead and should not be used for normal control flow.
**Action:** Use `.where(...).firstOrNull` (natively available in Dart 3.0+) instead of `try-catch` with `firstWhere` when searching for a potentially non-existent element in an Iterable.
