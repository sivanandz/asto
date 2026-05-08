## 2025-02-27 - Security Fix: Ensure Cryptographically Secure Randomness
**Vulnerability:** Predictable PRNG for security-sensitive tarot drawing context.
**Learning:** The use of `math.Random()` with standard mixed entropy is vulnerable to predictable sequences.
**Prevention:** Utilizing `math.Random.secure()` alongside existing entropy values preserves functionality and random output variance without compromising predictability. Negative values from mixed entropy must be avoided by using `.abs()` before the modulo operator to prevent runtime issues.
