import '../database/database_helper.dart';
import '../models/birth_chart.dart';
import '../models/user_profile.dart';
import '../services/astrology_calculator.dart';

class ChartRepository {
  final DatabaseHelper _db;

  ChartRepository(this._db);

  Future<BirthChart> createChart(
    UserProfile user, {
    ChartType type = ChartType.western,
    AyanamsaType? ayanamsa,
  }) async {
    final chart = AstrologyCalculator.calculateChart(
      user,
      type: type,
      ayanamsa: ayanamsa,
    );

    await _db.insertBirthChart(chart);
    return chart;
  }

  Future<BirthChart?> getChart(String id) async {
    return await _db.getBirthChart(id);
  }

  Future<List<BirthChart>> getUserCharts(String userId) async {
    return await _db.getBirthChartsByUser(userId);
  }

  Future<BirthChart?> getLatestChart(String userId) async {
    final charts = await getUserCharts(userId);
    return charts.isNotEmpty ? charts.first : null;
  }

  Future<void> deleteChart(String id) async {
    await _db.deleteBirthChart(id);
  }

  Future<BirthChart> regenerateChart(
    UserProfile user,
    BirthChart oldChart,
  ) async {
    // Delete old chart
    await deleteChart(oldChart.id);
    
    // Create new chart with same settings
    return await createChart(
      user,
      type: oldChart.type,
      ayanamsa: oldChart.ayanamsa,
    );
  }
}