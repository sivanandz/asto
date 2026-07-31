## 2024-05-15 - Missing HTTP request timeouts and unsanitized exceptions
**Vulnerability:** External HTTP requests lacked a timeout mechanism, which could lead to resource exhaustion if the external server is unresponsive. Additionally, exceptions were throwing raw HTTP status codes and exception strings, which could leak implementation details or sensitive state.
**Learning:** It is crucial to always add a reasonable timeout to network calls and sanitize error messages before presenting them or passing them up the stack.
**Prevention:** Use `.timeout(const Duration(seconds: 10))` on HTTP methods and replace leaked strings with generic error messages in catch/else blocks.
