## 2026-05-24 - Insecure PRNG in Tarot draws
**Vulnerability:** Predictable PRNG used for sensitive random card selection.
**Learning:** Entropy alone isn't enough if seeded into an insecure PRNG. Tarot draws need cryptographic security.
**Prevention:** Use math.Random.secure() with the hybrid entropy pattern.
