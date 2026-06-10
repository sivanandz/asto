## 2024-10-25 - Uncapped External HTTP Requests & Raw Error Leakage
**Vulnerability:** External HTTP requests (Nominatim API) lacked explicit timeouts, and catch blocks leaked raw exception details and HTTP status codes.
**Learning:** External APIs can hang indefinitely causing resource exhaustion (DoS). Raw exceptions can leak implementation details or internal state.
**Prevention:** Always append `.timeout()` to external network requests and throw generic, sanitized error messages to the user.
