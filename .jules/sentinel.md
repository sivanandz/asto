## 2024-06-20 - Prevent Information Disclosure and Resource Exhaustion
**Vulnerability:** External HTTP requests lacked timeouts, risking resource exhaustion, and exception blocks leaked raw exception details ($e) and HTTP status codes.
**Learning:** All external network calls must enforce a timeout to prevent hanging connections, and error messages must be sanitized to prevent leaking internal system details or stack traces to end users.
**Prevention:** Always append `.timeout()` to HTTP requests and throw generic error messages in catch blocks.
