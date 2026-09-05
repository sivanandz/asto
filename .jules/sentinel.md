## 2024-05-24 - Missing Timeout and Error Leakage in Location Service
**Vulnerability:** External HTTP requests in `lib/services/location_service.dart` (using `http.get`) do not specify timeouts, and their exception catch blocks throw raw error details (`$e`).
**Learning:** This exposes the application to resource exhaustion if the remote endpoint hangs (Server-Side Request Forgery risks/DoS) and leaks internal exception/network details to callers (and potentially UI) via the thrown exceptions.
**Prevention:** Always add a `.timeout()` (e.g., `timeout(const Duration(seconds: 10))`) to network requests and sanitize/generalize thrown error messages while optionally internally logging the raw exception for debuggability.
