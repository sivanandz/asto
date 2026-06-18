## 2024-06-18 - AstrologyCalculator testing
**What:** Created robust testing for AstrologyCalculator.
**Learning:** Found multiple missing runtime dependencies (`math.radians` missing in dart:math, fixed via `math_utils.dart` pattern) while testing the calculation.
**Action:** Always run standard tests when writing them! Testing helped identify syntax and structural runtime errors that the linter correctly flagged but were untested.
