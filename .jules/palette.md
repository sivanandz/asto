## 2024-07-31 - Vedic Chart Style Settings Configured
**Learning:** Adding the settings page toggle button required extracting a shared preference manager and linking the state from AppProvider with Consumer and didChangeDependencies.
**Action:** Store simple enum preferences directly into shared_preferences and connect global config updates to global UI listeners using Consumer widgets instead of local Component states for unified settings synchronization.
