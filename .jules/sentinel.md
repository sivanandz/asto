## 2024-06-21 - Missing HTTP Timeouts & Error Leakage
**Vulnerability:** External HTTP requests lacked timeouts and error catch blocks leaked raw exception details and HTTP status codes.
**Learning:** Without explicit timeouts, HTTP requests can hang indefinitely leading to resource exhaustion. Exposing raw exception details can leak sensitive infrastructure or implementation details to the user or logs.
**Prevention:** Always append `.timeout()` to network requests and throw sanitized, generic error messages in catch blocks.
