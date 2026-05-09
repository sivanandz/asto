## 2024-05-09 - Remove redundant Tarot delay
**Learning:** Found that `tarot_screen.dart` has a `Future.delayed(const Duration(seconds: 2));` AND `app_provider.dart` also has a `Future.delayed(const Duration(seconds: 2));` when calling `drawTarotCards()`. This leads to 4+ seconds of delay in total for drawing cards, which is a redundant UI-level delay.
**Action:** Remove the redundant `Future.delayed` in `tarot_screen.dart` to make the UI much faster, avoiding unnecessary waiting time while relying purely on `app_provider.dart` for the intended 2s sensor delay.
