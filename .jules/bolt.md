## 2024-07-03 - Use const for static maps in frequently called functions
**Learning:** In Dart and Flutter, using `final` for static maps that contain only compile-time constants (e.g., enums to strings) within frequently called functions like `CustomPainter.paint` or `build` causes unnecessary repeated memory allocations and garbage collection overhead.
**Action:** Use `const` instead of `final` for static maps containing only compile-time constants to ensure compile-time canonicalization and improve performance.
