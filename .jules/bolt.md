## 2024-05-24 - Avoid try-catch for control flow
**Learning:** Dart's exception handling incurs significant performance overhead. Using try-catch with Iterable.firstWhere is a performance anti-pattern.
**Action:** Use `.where(...).firstOrNull` (or a simple for loop) instead of `try-catch` around `firstWhere`.
