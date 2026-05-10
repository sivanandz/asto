## 2026-05-10 - Added Network Timeouts
**Vulnerability:** External HTTP calls in LocationService lacked explicit timeouts.
**Learning:** Default HTTP client behavior in Dart can hang indefinitely if the server is unresponsive, leading to potential resource exhaustion (client-side DoS).
**Prevention:** Always append `.timeout(const Duration(seconds: 10))` or similar bounds to network requests.
