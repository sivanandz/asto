## 2024-06-30 - Compile-Time Map Optimization
**Learning:** In Dart, declaring maps that only contain compile-time constants using `final` inside frequently executed functions (like `CustomPainter.paint` or Flutter's `build`) results in unnecessary memory allocations per execution.
**Action:** Always use `const` for local maps with compile-time constants (e.g. enum-to-string mappings) in rendering or calculation paths to ensure canonicalization and reduce garbage collection overhead.
