## 2024-06-19 - Missing HTTP Timeouts and Error Leakage
**Vulnerability:** External HTTP requests lacked timeouts and error catch blocks threw raw exception details including `$e` and HTTP status codes.
**Learning:** In Dart, `http.get` does not have a default timeout, which can cause resource exhaustion if the remote server hangs. Exposing raw error information leaks application internals.
**Prevention:** All external HTTP requests must include `.timeout()` and error handling must return sanitized, generic error messages.
