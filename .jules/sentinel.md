## 2024-05-24 - Unbounded HTTP Requests in Dart
**Vulnerability:** Found `http.get` calls in `LocationService` without explicit timeouts and catching unhandled raw exceptions leaking system error messages.
**Learning:** In Dart/Flutter, the default `http` package doesn't enforce timeouts. Without `.timeout()`, calls can hang indefinitely causing resource exhaustion and blocking async operations. Additionally, raw Exception string interpolation (e.g. `Exception('error: $e')`) can leak internal network structures or unhandled stack traces.
**Prevention:** Always append `.timeout(const Duration(seconds: X))` to external network calls in Dart, and throw sanitized, generic exception messages on failure, logging the raw details internally if needed.
