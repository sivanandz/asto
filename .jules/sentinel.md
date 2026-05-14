## 2026-05-14 - Secure Randomization for Entropy
**Vulnerability:** Weak pseudo-random number generator (PRNG) `math.Random(mixedEntropy)` was used for sensitive randomization (tarot draws), which could lead to predictable outcomes.
**Learning:** Even when mixing in physical entropy (like sensor data), using a deterministic PRNG seeded with that entropy is less secure than using a cryptographically secure RNG.
**Prevention:** Use `math.Random.secure()` for all sensitive randomizations. To incorporate physical entropy without compromising security, use the hybrid pattern: `(math.Random.secure().nextInt(max) + entropyOffset.abs()) % max`.
