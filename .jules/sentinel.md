## 2024-05-13 - [HTTP Request Timeout missing]
**Vulnerability:** Missing timeout configurations on external HTTP calls in `LocationService`.
**Learning:** Without explicit timeouts, network calls can hang indefinitely if the server is unresponsive, leading to potential resource exhaustion and application hangs.
**Prevention:** Always enforce HTTP request timeouts (e.g., `.timeout(const Duration(seconds: 10))`) on network calls to prevent application hangs and potential resource exhaustion vulnerabilities.
