## 2024-05-19 - Missing Semantic Labels on Icon Buttons
**Learning:** Found that `IconButton` widgets in flutter applications lacking the `tooltip` property lack semantic labels, which makes the app largely inaccessible for screen reader users on mobile (especially on Android TalkBack/iOS VoiceOver).
**Action:** When auditing or implementing icon-only buttons (`IconButton`), always ensure an explicit `tooltip` is present to act as the semantic label.
