## 2024-06-08 - Added Request Timeouts and Error Sanitization in LocationService
**Vulnerability:** External HTTP GET requests to Nominatim APIs lacked timeouts (leading to potential application hangs/Denial of Service) and raw exceptions (including HTTP status codes) were leaked directly in error messages.
**Learning:** Dart `http` library does not set a default timeout. Unhandled long-running network requests can exhaust app resources. Catch blocks often inadvertently leak system or HTTP details via default exception casting (`$e`).
**Prevention:** All external HTTP calls must append `.timeout(Duration(...))` to enforce limits. Catch blocks must throw sanitized, generic messages instead of interpolating the raw exception.
