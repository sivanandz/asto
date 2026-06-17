import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_profile.dart';
import '../models/birth_chart.dart';
import '../models/tarot_card.dart';
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
      if (_currentUser != null) {
        await _loadCurrentChart();
      }
      await _loadTarotReadings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // User Profile Methods
  Future<void> createUserProfile(UserProfile profile) async {
    _setLoading(true);
    try {
      await _db.insertUserProfile(profile);
      _currentUser = profile;
      await _generateChart();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    _setLoading(true);
    try {
      await _db.updateUserProfile(profile);
      _currentUser = profile;
      await _generateChart(); // Regenerate chart with new data
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserProfile(String userId) async {
    _setLoading(true);
    try {
      _currentUser = await _db.getUserProfile(userId);
      if (_currentUser != null) {
        await _loadCurrentChart();
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteUserProfile(String userId) async {
    _setLoading(true);
    try {
      await _db.deleteUserProfile(userId);
      if (_currentUser?.id == userId) {
        _currentUser = null;
        _currentChart = null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Chart Methods
  Future<void> _loadCurrentChart() async {
    if (_currentUser == null) return;
    
    final charts = await _db.getBirthChartsByUser(_currentUser!.id);
    if (charts.isNotEmpty) {
      _currentChart = charts.first;
    } else {
      await _generateChart();
    }
  }

  Future<void> _generateChart() async {
    if (_currentUser == null) return;

    final chart = AstrologyCalculator.calculateChart(
      _currentUser!,
      type: ChartType.western,
    );

    await _db.insertBirthChart(chart);
    _currentChart = chart;
  }

  Future<void> generateVedicChart(AyanamsaType ayanamsa) async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      final chart = AstrologyCalculator.calculateChart(
        _currentUser!,
        type: ChartType.vedicNorthIndian,
        ayanamsa: ayanamsa,
      );

      await _db.insertBirthChart(chart);
      _currentChart = chart;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Tarot Methods
  Future<void> _loadTarotReadings() async {
    _tarotReadings = await _db.getAllTarotReadings();
  }

  Future<TarotReading> drawTarotCards(String question, {int cardCount = 3}) async {
    _setLoading(true);
    try {
      // Use entropy random with sensors for magical feel
      final positions = ['Past', 'Present', 'Future'];
      
      // Create a custom reading with sensor entropy
      final draws = <TarotDraw>[];
      final entropyRandom = EntropyRandom();
      
      // Collect sensor data while showing animation
      entropyRandom.startCollecting();
      
      // Wait a bit for sensor data collection
      await Future.delayed(const Duration(seconds: 2));
      
      final cardIndices = entropyRandom.nextUniqueInts(cardCount, tarotDeck.length);
      
      for (int i = 0; i < cardIndices.length; i++) {
        final card = tarotDeck[cardIndices[i]];
        final isReversed = entropyRandom.nextInt(2) == 0;
        
        draws.add(TarotDraw(
          card: card,
          position: isReversed ? TarotPosition.reversed : TarotPosition.upright,
          positionName: positions[i % positions.length],
        ));
      }
      
      entropyRandom.stopCollecting();

      final reading = TarotReading(
        question: question,
        draws: draws,
        interpretation: _generateInterpretation(draws),
      );

      await _db.insertTarotReading(reading);
      _tarotReadings.insert(0, reading);
      notifyListeners();
      
      return reading;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTarotReading(String readingId) async {
    await _db.deleteTarotReading(readingId);
    _tarotReadings.removeWhere((r) => r.id == readingId);
    notifyListeners();
  }

  Future<void> deleteAllTarotReadings() async {
    await _db.deleteAllTarotReadings();
    _tarotReadings.clear();
    notifyListeners();
  }

  String _generateInterpretation(List<TarotDraw> draws) {
    if (draws.isEmpty) return '';
    
    final buffer = StringBuffer();
    buffer.writeln('Your cards reveal a journey of transformation.');
    buffer.writeln();
    
    for (final draw in draws) {
      buffer.writeln('${draw.positionName}: ${draw.card.displayName}');
      buffer.writeln(draw.position == TarotPosition.upright 
          ? draw.card.meaningUpright 
          : draw.card.meaningReversed);
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  // Utility Methods
  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Get chart data for UI
  List<PlanetPosition> getPlanetsInHouse(int house) {
    if (_currentChart == null) return [];
    return _currentChart!.positions
        .where((p) => p.house == house && p.planet != PlanetType.ascendant)
        .toList();
  }

  PlanetPosition? get ascendant => _currentChart?.ascendant;
  PlanetPosition? get sun => _currentChart?.sun;
  PlanetPosition? get moon => _currentChart?.moon;
  
  String get sunSign => sun?.sign.name ?? '';
  String get moonSign => moon?.sign.name ?? '';
  String get risingSign => ascendant?.sign.name ?? '';
}