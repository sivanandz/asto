## 2024-06-25 - Timeout missing on external API calls
**Vulnerability:** External HTTP GET requests (`http.get`) in `LocationService` (to Nominatim) did not have a timeout configured.
**Learning:** This exposes the application to resource exhaustion or indefinite hangs if the external service is slow or unresponsive.
**Prevention:** Always append `.timeout()` to external network requests, especially in Dart/Flutter.
