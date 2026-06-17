## 2024-05-24 - Unbounded HTTP Requests & Error Leakage
**Vulnerability:** External `http.get` calls lacked explicit timeouts (risking resource exhaustion) and leaked raw exception details and HTTP status codes via `throw Exception(e)` to the calling context.
**Learning:** Dart's `http` package does not enforce a default timeout, meaning a hanging external server will block the client thread indefinitely. Catching and rethrowing raw exceptions can inadvertently leak system details to the UI if not sanitized.
**Prevention:** Always append `.timeout()` to external HTTP calls and catch specific exceptions, mapping them to generic, safe error messages before throwing them up the stack.
