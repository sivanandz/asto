## 2024-05-18 - Prevent HTTP Resource Exhaustion and Data Leakage
**Vulnerability:** External HTTP requests lacked explicit timeouts, risking resource exhaustion, and raw exceptions/HTTP status codes were leaked in error messages.
**Learning:** Dart's `http.get` does not have a default timeout. Unsanitized error messages can leak internal system details or network topography to users/attackers.
**Prevention:** Always append `.timeout()` to external HTTP requests and throw sanitized, generic error messages in catch blocks.
