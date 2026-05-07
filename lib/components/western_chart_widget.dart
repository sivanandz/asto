import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/birth_chart.dart';
import '../models/planet_position.dart';
import '../theme.dart';

class WesternChartWidget extends StatelessWidget {
  final BirthChart chart;
  final double size;

  const WesternChartWidget({
    super.key,
    required this.chart,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.borderColor, width: 2),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: WesternChartPainter(chart: chart),
      ),
    );
  }
}

class WesternChartPainter extends CustomPainter {
  final BirthChart chart;

  WesternChartPainter({required this.chart});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Draw zodiac wheel
    _drawZodiacWheel(canvas, center, radius);
    
    // Draw houses
    _drawHouses(canvas, center, radius);
    
    // Draw planets
    _drawPlanets(canvas, center, radius * 0.75);
    
    // Draw center info
    _drawCenterInfo(canvas, center);
  }

  void _drawZodiacWheel(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppTheme.borderColor;

    // Outer circle
    canvas.drawCircle(center, radius, paint);
    
    // Inner circle
    canvas.drawCircle(center, radius * 0.85, paint);
    canvas.drawCircle(center, radius * 0.6, paint);

    // Draw zodiac divisions (12 segments)
    final ascendant = chart.ascendant;
    final ascendantDegree = ascendant != null 
        ? (ascendant.sign.index * 30 + ascendant.degree)
        : 0;

    for (int i = 0; i < 12; i++) {
      final angle = ((i * 30 - ascendantDegree) - 90) * math.pi / 180.0;
      final outer = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final inner = Offset(
        center.dx + radius * 0.85 * math.cos(angle),
        center.dy + radius * 0.85 * math.sin(angle),
      );
      canvas.drawLine(inner, outer, paint);

      // Draw zodiac symbols
      final sign = ZodiacSign.values[i];
      final textAngle = ((i * 30 + 15 - ascendantDegree) - 90) * math.pi / 180.0;
      final textPos = Offset(
        center.dx + radius * 0.92 * math.cos(textAngle),
        center.dy + radius * 0.92 * math.sin(textAngle),
      );
      _drawZodiacSymbol(canvas, sign, textPos);
    }
  }

  void _drawHouses(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppTheme.borderColor.withOpacity(0.5);

    final ascendant = chart.ascendant;
    if (ascendant == null) return;

    final ascendantDegree = ascendant.sign.index * 30 + ascendant.degree;

    // Draw house cusps
    for (int i = 0; i < 12; i++) {
      // Simplified house calculation (equal houses)
      final angle = ((i * 30 - ascendantDegree) - 90) * math.pi / 180.0;
      final outer = Offset(
        center.dx + radius * 0.85 * math.cos(angle),
        center.dy + radius * 0.85 * math.sin(angle),
      );
      final inner = Offset(
        center.dx + radius * 0.6 * math.cos(angle),
        center.dy + radius * 0.6 * math.sin(angle),
      );
      canvas.drawLine(inner, outer, paint);

      // House numbers
      final textAngle = ((i * 30 + 15 - ascendantDegree) - 90) * math.pi / 180.0;
      final textPos = Offset(
        center.dx + radius * 0.72 * math.cos(textAngle),
        center.dy + radius * 0.72 * math.sin(textAngle),
      );
      _drawText(canvas, '${i + 1}', textPos, 10, AppTheme.textMuted);
    }
  }

  void _drawPlanets(Canvas canvas, Offset center, double radius) {
    final ascendant = chart.ascendant;
    final ascendantDegree = ascendant != null 
        ? (ascendant.sign.index * 30 + ascendant.degree)
        : 0;

    // Group planets by position to avoid overlap
    final Map<double, List<PlanetPosition>> planetGroups = {};
    
    for (final position in chart.positions) {
      if (position.planet == PlanetType.ascendant) continue;
      
      final longitude = position.sign.index * 30 + position.degree;
      final adjustedLon = (longitude - ascendantDegree + 360) % 360;
      
      // Round to nearest 5 degrees for grouping
      final groupKey = (adjustedLon / 5).round() * 5.0;
      planetGroups.putIfAbsent(groupKey, () => []).add(position);
    }

    // Draw planets
    for (final entry in planetGroups.entries) {
      final angle = (entry.key - 90) * math.pi / 180.0;
      final basePos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      for (int i = 0; i < entry.value.length; i++) {
        final planet = entry.value[i];
        final offset = i * 15.0;
        final planetPos = Offset(
          basePos.dx + offset * math.cos(angle + math.pi / 2),
          basePos.dy + offset * math.sin(angle + math.pi / 2),
        );
        
        _drawPlanetSymbol(canvas, planet.planet, planetPos, planet.isRetrograde);
      }
    }
  }

  void _drawCenterInfo(Canvas canvas, Offset center) {
    final sun = chart.sun;
    final moon = chart.moon;
    final rising = chart.ascendant;

    if (sun != null && moon != null && rising != null) {
      _drawText(
        canvas,
        '☉ ${sun.sign.name.substring(0, 3).toUpperCase()}',
        Offset(center.dx, center.dy - 15),
        12,
        AppTheme.primary,
      );
      _drawText(
        canvas,
        '☽ ${moon.sign.name.substring(0, 3).toUpperCase()}',
        Offset(center.dx, center.dy),
        12,
        AppTheme.tertiary,
      );
      _drawText(
        canvas,
        'AC ${rising.sign.name.substring(0, 3).toUpperCase()}',
        Offset(center.dx, center.dy + 15),
        12,
        AppTheme.textMain,
      );
    }
  }

  void _drawZodiacSymbol(Canvas canvas, ZodiacSign sign, Offset position) {
    final symbols = {
      ZodiacSign.aries: '♈',
      ZodiacSign.taurus: '♉',
      ZodiacSign.gemini: '♊',
      ZodiacSign.cancer: '♋',
      ZodiacSign.leo: '♌',
      ZodiacSign.virgo: '♍',
      ZodiacSign.libra: '♎',
      ZodiacSign.scorpio: '♏',
      ZodiacSign.sagittarius: '♐',
      ZodiacSign.capricorn: '♑',
      ZodiacSign.aquarius: '♒',
      ZodiacSign.pisces: '♓',
    };
    _drawText(canvas, symbols[sign] ?? '', position, 14, AppTheme.primary);
  }

  void _drawPlanetSymbol(Canvas canvas, PlanetType planet, Offset position, bool retrograde) {
    final symbols = {
      PlanetType.sun: '☉',
      PlanetType.moon: '☽',
      PlanetType.mercury: '☿',
      PlanetType.venus: '♀',
      PlanetType.mars: '♂',
      PlanetType.jupiter: '♃',
      PlanetType.saturn: '♄',
      PlanetType.uranus: '♅',
      PlanetType.neptune: '♆',
      PlanetType.pluto: '♇',
      PlanetType.rahu: '☊',
      PlanetType.ketu: '☋',
    };

    final text = symbols[planet] ?? '•';
    _drawText(canvas, text, position, 16, AppTheme.textMain);

    if (retrograde) {
      _drawText(
        canvas,
        '℞',
        Offset(position.dx + 8, position.dy - 8),
        8,
        AppTheme.error,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, double fontSize, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}