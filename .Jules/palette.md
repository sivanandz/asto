## 2026-08-08 - Accessible tooltips
**Learning:** Found multiple icon-only buttons missing `tooltip` attributes natively. Flutter provides standard `tooltip` attributes on elements like `IconButton`, which is critical for making them readable by screen readers.
**Action:** Always add semantic tooltips explicitly on buttons containing only icons, as a11y labels aren't added magically.
