## 2024-05-18 - Prevent Resource Exhaustion and Information Leakage in External HTTP Calls
**Vulnerability:** External `http.get` calls lacked explicit timeouts (risking resource exhaustion) and exception catch blocks leaked raw exception details and HTTP status codes.
**Learning:** Dart `http.get` does not have a default timeout; it can hang indefinitely if the remote server is unresponsive. Catch blocks must throw generic, sanitized messages.
**Prevention:** Always append `.timeout(const Duration(seconds: 10))` to HTTP calls and sanitize error throws to avoid exposing internals.
