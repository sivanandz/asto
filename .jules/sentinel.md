## 2026-06-24 - Missing HTTP Timeouts and Error Leakage
**Vulnerability:** External HTTP requests lacked explicit timeouts, allowing potential resource exhaustion (DoS), and error handling leaked raw exception details and status codes to the calling layer.
**Learning:** Default HTTP clients do not have inherent timeouts, and raw error injection into exception strings exposes internal state.
**Prevention:** Always append `.timeout()` to external HTTP calls and return generic, sanitized error messages from catch blocks.
