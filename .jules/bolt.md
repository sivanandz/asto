## 2024-05-24 - Dart Performance Anti-Pattern: Exception Handling for Control Flow
**Learning:** Using `try-catch` blocks to handle expected "not found" conditions (like catching StateError from `Iterable.firstWhere`) incurs a massive performance overhead in Dart compared to standard control flow.
**Action:** Replace `try { list.firstWhere(condition) } catch (_) { return null; }` with `list.where(condition).firstOrNull` (or a `for` loop) in frequently called methods.
