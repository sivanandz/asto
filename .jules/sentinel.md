## 2024-06-28 - Secure external HTTP requests
**Vulnerability:** Missing timeouts on external HTTP requests and exposure of raw exception details/status codes in error messages.
**Learning:** The app's location service was vulnerable to resource exhaustion (hanging requests) and information leakage (exposing server-side errors/status codes to the client).
**Prevention:** Always append `.timeout()` to network calls and throw generic, sanitized error messages rather than raw exception details.
