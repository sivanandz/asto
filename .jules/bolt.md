## 2024-08-04 - Const Map Allocation Bottleneck
**Learning:** In Flutter's rendering loop (like `CustomPainter.paint`), declaring static maps using `final` causes unnecessary memory allocations and GC overhead on every frame, which can be significant when complex maps (like planet/zodiac symbol lookups) are instantiated rapidly.
**Action:** Always use `const` instead of `final` for static mapping dictionaries inside frequently called functions if all keys and values are compile-time constants (e.g., enums to strings). This ensures compile-time canonicalization.
