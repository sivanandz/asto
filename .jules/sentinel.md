## 2024-06-12 - Missing Timeouts on External HTTP Requests
**Vulnerability:** External HTTP calls in `LocationService` (to OpenStreetMap Nominatim API) lacked explicit timeouts, making the application vulnerable to resource exhaustion and degraded user experience if the external service hangs or responds slowly.
**Learning:** Dart's default `http.get` does not have a built-in timeout, and it must be explicitly configured. Error handling often leaks raw exception strings which can expose internal stack details to end users.
**Prevention:** Always append `.timeout(const Duration(seconds: X))` to external API calls and map raw exceptions to sanitized, generic user-facing messages in the catch block.
