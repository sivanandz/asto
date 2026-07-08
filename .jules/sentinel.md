## 2026-07-08 - Prevent Resource Exhaustion and Information Leakage in HTTP Requests
**Vulnerability:** External HTTP requests lacked explicit timeouts and exception catch blocks leaked raw exception details and HTTP status codes.
**Learning:** Dart's http package does not have a default timeout, making applications vulnerable to resource exhaustion if external endpoints hang. Exposing raw errors and status codes can leak internal configurations or API details.
**Prevention:** Always append .timeout(const Duration(seconds: 10)) to HTTP requests and throw sanitized, generic error messages in catch blocks.
