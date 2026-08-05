## 2026-08-05 - [Const Map Optimization]
**Learning:** Dart/Flutter static analysis does not always warn about `final` local variables being created on every function call. When maps are used inside `CustomPainter.paint` or `build` methods, using `final` forces a new map allocation on every frame, which can cause garbage collection overhead.
**Action:** Always proactively review frequently called methods (like paints or builds) for static lookup maps that can be converted from `final` to `const`.
