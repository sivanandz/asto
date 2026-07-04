## 2026-07-04 - HTTP Timeout and Exception Sanitization
**Vulnerability:** HTTP requests lacked timeouts leading to potential resource exhaustion, and exception blocks leaked raw error details and HTTP status codes.
**Learning:** Dart's `http.get` does not have a default timeout, which can cause the app to hang indefinitely on network issues. Exceptions can expose internal application structure or underlying server details to the user.
**Prevention:** Always append `.timeout()` to external HTTP requests and use generic, sanitized error messages in `catch` and `else` blocks when dealing with network operations.
