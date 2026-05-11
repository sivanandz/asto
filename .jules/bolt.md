## 2026-05-11 - Duplicate Asynchronous UI Delays
**Learning:** The `AppProvider.drawTarotCards` method manages its own 2-second delay for sensor data collection. However, the UI (`TarotScreen`) had a redundant 2-second delay built in. This duplicate delay in UI components that wrap data providers can unknowingly block the main thread or degrade the user experience significantly by doubling the expected wait time.
**Action:** When inspecting UI delays, always check the underlying provider or service methods to see if the delay is already handled there for data collection or processing.
