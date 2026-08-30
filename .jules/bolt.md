## 2024-05-30 - Replace try-catch with firstOrNull for Dart performance
**Learning:** Using `try-catch` blocks around `firstWhere` for control flow incurs significant performance overhead in Dart.
**Action:** Use `.where(...).firstOrNull` (or a simple loop) instead of catching exceptions when an element is not found, as it avoids the expensive stack trace generation.
