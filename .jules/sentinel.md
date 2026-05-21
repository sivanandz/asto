## 2024-05-24 - Network Request Timeout Vulnerability
**Vulnerability:** Missing timeouts on external HTTP GET requests in `LocationService` (nominatim geocoding).
**Learning:** Dart's `http` package does not enforce a default timeout, leaving the application vulnerable to hangs or resource exhaustion if the remote server is unresponsive.
**Prevention:** Always append `.timeout(const Duration(seconds: 10))` to network calls to fail securely and prevent UI freezes.
