## 2024-05-18 - Prevent Resource Exhaustion & Information Leakage in HTTP Calls
**Vulnerability:** External HTTP requests lacked explicit timeouts (potential resource exhaustion) and exception catch blocks threw raw exception details and HTTP status codes (information leakage).
**Learning:** Dart/Flutter `http.get` calls do not have a default timeout, which can cause the app to hang indefinitely on network failure. Leaking raw exceptions (`$e`) can expose internal implementation details to the UI layer.
**Prevention:** Always append `.timeout(const Duration(seconds: 10))` to HTTP requests. Catch blocks should log the raw error internally (e.g., `debugPrint`) but throw sanitized, generic error messages to callers.
