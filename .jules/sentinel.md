## 2024-05-24 - Fix Insecure PRNG
**Vulnerability:** Application was using math.Random with a custom pseudo-random seed instead of math.Random.secure().
**Learning:** Standard PRNGs are predictable and should not be used for cryptographic operations or where unpredictability is a security requirement.
**Prevention:** Always use math.Random.secure() when unpredictability is required, avoiding manual seeding logic.
