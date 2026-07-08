## 2024-07-08 - Use const for static maps in Dart
**Learning:** Dart's memory allocation creates overhead when declaring static maps (like enums to string symbols) using `final` inside frequently executed functions (such as `build` methods or `CustomPainter.paint`).
**Action:** Always use `const` instead of `final` for static maps containing only compile-time constants within frequently called functions to ensure compile-time canonicalization and prevent unnecessary memory allocations.
