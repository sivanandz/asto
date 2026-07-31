#!/bin/bash
cat << 'INNER_EOF' > /tmp/app_provider.patch
<<<<<<< SEARCH
import '../services/astrology_calculator.dart';
import '../data/tarot_deck.dart';
import 'dart:math' as math;

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // State
  UserProfile? _currentUser;
  BirthChart? _currentChart;
  List<TarotReading> _tarotReadings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  UserProfile? get currentUser => _currentUser;
  BirthChart? get currentChart => _currentChart;
  List<TarotReading> get tarotReadings => _tarotReadings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _currentUser != null;

  // Initialize - load default user
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _db.getDefaultUserProfile();
=======
import 'package:shared_preferences/shared_preferences.dart';
import '../services/astrology_calculator.dart';
import '../data/tarot_deck.dart';
import '../components/vedic_chart_widget.dart';
import 'dart:math' as math;

class AppProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  static const String _vedicChartStyleKey = 'vedic_chart_style';

  // State
  UserProfile? _currentUser;
  BirthChart? _currentChart;
  List<TarotReading> _tarotReadings = [];
  bool _isLoading = false;
  String? _error;
  VedicChartStyle _vedicChartStyle = VedicChartStyle.northIndian;

  // Getters
  UserProfile? get currentUser => _currentUser;
  BirthChart? get currentChart => _currentChart;
  List<TarotReading> get tarotReadings => _tarotReadings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _currentUser != null;
  VedicChartStyle get vedicChartStyle => _vedicChartStyle;

  // Initialize - load default user
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStyleIndex = prefs.getInt(_vedicChartStyleKey);
      if (savedStyleIndex != null && savedStyleIndex >= 0 && savedStyleIndex < VedicChartStyle.values.length) {
        _vedicChartStyle = VedicChartStyle.values[savedStyleIndex];
      }

      _currentUser = await _db.getDefaultUserProfile();
>>>>>>> REPLACE
<<<<<<< SEARCH
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // User Profile Methods
=======
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> setVedicChartStyle(VedicChartStyle style) async {
    _vedicChartStyle = style;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_vedicChartStyleKey, style.index);
    } catch (e) {
      _error = e.toString();
    }
  }

  // User Profile Methods
>>>>>>> REPLACE
INNER_EOF
