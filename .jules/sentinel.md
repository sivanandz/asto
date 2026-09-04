## 2023-10-27 - Security: External HTTP Requests

**Vulnerability:** External HTTP requests lacked timeouts (risking resource exhaustion) and exception handlers leaked raw error messages/status codes.
**Learning:** External services like Nominatim can be slow or unavailable. Without timeouts, the app can hang indefinitely. Furthermore, exposing raw exception messages or HTTP status codes can leak internal details or cause unhandled exceptions if the error format changes.
**Prevention:** Always add an explicit `.timeout()` mechanism to external HTTP requests (e.g., `.timeout(const Duration(seconds: 10))`). Ensure catch blocks throw sanitized, generic error messages rather than leaking raw exception details (`$e`) or HTTP status codes. Log raw details internally via `debugPrint` before throwing.
