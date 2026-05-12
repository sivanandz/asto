## 2024-05-24 - Missing HTTP Timeout Configuration
**Vulnerability:** HTTP requests in `LocationService` lacked timeout configuration.
**Learning:** Dart's `http` package doesn't have a default timeout. Unbounded requests can lead to application hangs and potential resource exhaustion.
**Prevention:** Always append `.timeout(const Duration(seconds: 10))` or similar to `http.get`, `http.post`, etc., or use a custom `http.Client` wrapper that enforces timeouts globally.
