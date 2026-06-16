## 2024-05-18 - Unsanitized Exception Leakage & Missing Timeouts
**Vulnerability:** External HTTP requests in `LocationService` lacked timeouts, and exceptions were surfacing raw `$e` details and raw `response.statusCode` directly.
**Learning:** This could lead to resource exhaustion (DoS risk) if the external geocoding API hangs, and leaking raw exception details violates secure failing principles by potentially exposing stack traces or network internals to the client.
**Prevention:** Always append `.timeout()` to network calls to guarantee a finite operation time. Catch blocks must throw sanitized, generic errors (e.g., "Please check your connection.") instead of exposing the raw exception.
