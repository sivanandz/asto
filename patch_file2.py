import re

with open('lib/providers/app_provider.dart', 'r') as f:
    content = f.read()

# Add imports (being very careful)
if "import 'package:shared_preferences/shared_preferences.dart';" not in content:
    content = content.replace("import 'dart:math' as math;", "import 'package:shared_preferences/shared_preferences.dart';\nimport '../components/vedic_chart_widget.dart';\nimport '../models/planet_position.dart';\nimport 'dart:math' as math;")

if "static const String _vedicChartStyleKey" not in content:
    content = content.replace("final DatabaseHelper _db = DatabaseHelper.instance;", "final DatabaseHelper _db = DatabaseHelper.instance;\n  static const String _vedicChartStyleKey = 'vedic_chart_style';")

if "VedicChartStyle _vedicChartStyle" not in content:
    content = content.replace("String? _error;", "String? _error;\n  VedicChartStyle _vedicChartStyle = VedicChartStyle.northIndian;")

if "VedicChartStyle get vedicChartStyle" not in content:
    content = content.replace("bool get hasUser => _currentUser != null;", "bool get hasUser => _currentUser != null;\n  VedicChartStyle get vedicChartStyle => _vedicChartStyle;")

if "final prefs = await SharedPreferences.getInstance();" not in content:
    prefs_init = """      final prefs = await SharedPreferences.getInstance();
      final savedStyleIndex = prefs.getInt(_vedicChartStyleKey);
      if (savedStyleIndex != null && savedStyleIndex >= 0 && savedStyleIndex < VedicChartStyle.values.length) {
        _vedicChartStyle = VedicChartStyle.values[savedStyleIndex];
      }

      _currentUser"""
    content = content.replace("      _currentUser", prefs_init, 1)

if "Future<void> setVedicChartStyle" not in content:
    set_method = """  Future<void> setVedicChartStyle(VedicChartStyle style) async {
    _vedicChartStyle = style;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_vedicChartStyleKey, style.index);
    } catch (e) {
      _error = e.toString();
    }
  }

  // User Profile Methods"""
    content = content.replace("  // User Profile Methods", set_method)

with open('lib/providers/app_provider.dart', 'w') as f:
    f.write(content)
