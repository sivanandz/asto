import 'package:flutter_test/flutter_test.dart';
import '../lib/models/birth_chart.dart';
import '../lib/models/planet_position.dart';
import '../lib/components/vedic_chart_widget.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('VedicChartWidget renders correctly', (WidgetTester tester) async {
    final positions = [
      PlanetPosition(planet: PlanetType.sun, sign: ZodiacSign.aries, house: 1, degree: 10.0, isRetrograde: false),
    ];

    final chart = BirthChart(
      id: 'test',
      userId: 'test_user',
      type: ChartType.vedicNorthIndian,
      positions: positions,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: VedicChartWidget(chart: chart),
      ),
    ));

    expect(find.byType(VedicChartWidget), findsOneWidget);
  });
}
