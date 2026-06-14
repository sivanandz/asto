
## 2024-05-24 - Missing Timeouts and Error Leakage in HTTP Requests
**Vulnerability:** External HTTP requests lacked timeouts leading to potential resource exhaustion, and raw exceptions/status codes were leaked in error messages.
**Learning:** External API calls must always be bounded by timeouts, and exception details should be genericized before bubbling up to prevent leaking internal state or network details.
**Prevention:** Always append `.timeout()` to `http.get` and manually scrub exception messages in `catch` blocks before re-throwing.
