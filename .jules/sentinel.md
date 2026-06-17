## 2026-06-17 - Add Timeouts and Sanitize Exceptions in HTTP Services
**Vulnerability:** External HTTP requests in `LocationService` lacked explicit timeouts, risking DoS via resource exhaustion. Furthermore, error handling leaked raw HTTP status codes and exception details (`$e`) which could expose internal environment info.
**Learning:** Always use `.timeout()` for all external network requests to fail securely. Never pass raw exception data to the frontend or user.
**Prevention:** Include explicit duration timeouts on network requests and sanitize error messages in catch blocks to return generic, user-friendly errors.
