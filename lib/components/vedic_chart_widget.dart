import 'package:flutter/material.dart';
import '../models/birth_chart.dart';
import '../models/planet_position.dart';
import '../theme.dart';

enum VedicChartStyle {
  northIndian,
  southIndian,
}

class VedicChartWidget extends StatelessWidget {
  final BirthChart chart;
  final VedicChartStyle style;
  final double size;

  const VedicChartWidget({
    super.key,
    required this.chart,
    this.style = VedicChartStyle.northIndian,
    this.size = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor, width: 2),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: VedicChartPainter(
          chart: chart,
          style: style,
        ),
      ),
    );
  }
}

class VedicChartPainter extends CustomPainter {
  final BirthChart chart;
  final VedicChartStyle style;

  VedicChartPainter({
    required this.chart,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (style == VedicChartStyle.northIndian) {
      _drawNorthIndianChart(canvas, size);
    } else {
      _drawSouthIndianChart(canvas, size);
    }
  }

  void _drawNorthIndianChart(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppTheme.borderColor;

    final padding = 20.0;
    final chartSize = size.width - 2 * padding;
    final cellSize = chartSize / 3;

    // Draw outer rectangle
    final rect = Rect.fromLTWH(padding, padding, chartSize, chartSize);
    canvas.drawRect(rect, paint);

    // Draw diagonal lines for diamond pattern (North Indian style)
    // Center cell is divided by X
    final centerLeft = Offset(padding + cellSize, padding + cellSize);
    final centerRight = Offset(padding + 2 * cellSize, padding + cellSize);
    final centerTop = Offset(padding + cellSize * 1.5, padding);
    final centerBottom = Offset(padding + cellSize * 1.5, padding + chartSize);

    // Draw center X
    canvas.drawLine(centerLeft, centerRight, paint);
    canvas.drawLine(centerTop, centerBottom, paint);

    // Draw diagonal corners
    // Top-left corner
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding + cellSize, padding + cellSize),
      paint,
    );
    // Top-right corner
    canvas.drawLine(
      Offset(padding + chartSize, padding),
      Offset(padding + 2 * cellSize, padding + cellSize),
      paint,
    );
    // Bottom-left corner
    canvas.drawLine(
      Offset(padding, padding + chartSize),
      Offset(padding + cellSize, padding + 2 * cellSize),
      paint,
    );
    // Bottom-right corner
    canvas.drawLine(
      Offset(padding + chartSize, padding + chartSize),
      Offset(padding + 2 * cellSize, padding + 2 * cellSize),
      paint,
    );

    // Draw house numbers and planets
    _drawNorthIndianHouses(canvas, size, padding, cellSize);
  }

  void _drawNorthIndianHouses(Canvas canvas, Size size, double padding, double cellSize) {
    // North Indian house arrangement (diamond pattern)
    // House 1 (Ascendant) is typically top-center or center-left
    final ascendant = chart.ascendant;
    final ascendantHouse = ascendant?.house ?? 1;

    // Pre-group planets by house to avoid O(N) filtering inside the render loop
    final Map<int, List<PlanetPosition>> planetsByHouse = {};
    for (final p in chart.positions) {
      planetsByHouse.putIfAbsent(p.house, () => []).add(p);
    }

    // House positions in 3x3 grid for North Indian
    final housePositions = [
      [12, 1, 2],
      [11, null, 3],
      [10, 9, 8],
      [null, 7, 6],
      [null, 5, 4],
    ];

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        int? houseNum;
        if (row == 0) houseNum = housePositions[0][col];
        else if (row == 1 && col == 0) houseNum = housePositions[1][0];
        else if (row == 1 && col == 2) houseNum = housePositions[1][2];
        else if (row == 2) houseNum = housePositions[2][col];

        if (houseNum == null) continue;

        // Adjust house number based on ascendant
        final actualHouse = ((houseNum - ascendantHouse + 12) % 12) + 1;
        
        final x = padding + col * cellSize + cellSize / 2;
        final y = padding + row * cellSize + cellSize / 2;

        // Draw house number
        _drawText(
          canvas,
          actualHouse.toString(),
          Offset(x - cellSize / 3, y - cellSize / 3),
          12,
          AppTheme.textMuted,
        );

        // Draw planets in this house
        final planets = planetsByHouse[actualHouse] ?? [];
        _drawPlanetsInCell(canvas, planets, Offset(x, y), cellSize);
      }
    }
  }

  void _drawSouthIndianChart(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppTheme.borderColor;

    final padding = 20.0;
    final chartSize = size.width - 2 * padding;
    final cellSize = chartSize / 4;

    // Draw 4x4 grid (South Indian style has fixed zodiac sign positions)
    for (int i = 0; i <= 4; i++) {
      // Horizontal lines
      canvas.drawLine(
        Offset(padding, padding + i * cellSize),
        Offset(padding + chartSize, padding + i * cellSize),
        paint,
      );
      // Vertical lines
      canvas.drawLine(
        Offset(padding + i * cellSize, padding),
        Offset(padding + i * cellSize, padding + chartSize),
        paint,
      );
    }

    // Draw zodiac signs in fixed positions
    _drawSouthIndianZodiac(canvas, size, padding, cellSize);
    
    // Draw planets
    _drawSouthIndianPlanets(canvas, padding, cellSize);
  }

  void _drawSouthIndianZodiac(Canvas canvas, Size size, double padding, double cellSize) {
    // South Indian has fixed zodiac positions
    // Pisces (12) is top-left, Aries (1) is top-middle, etc.
    final signPositions = [
      [11, 12, 1, 2],
      [10, null, null, 3],
      [9, null, null, 4],
      [8, 7, 6, 5],
    ];

    final signSymbols = ['♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓'];

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        final signNum = signPositions[row][col];
        if (signNum == null) continue;

        final x = padding + col * cellSize + cellSize / 2;
        final y = padding + row * cellSize + cellSize / 2;

        _drawText(
          canvas,
          signSymbols[signNum - 1],
          Offset(x, y - cellSize / 3),
          16,
          AppTheme.primary,
        );

        // Draw house number if ascendant falls here
        final ascendant = chart.ascendant;
        if (ascendant != null && ascendant.sign.index + 1 == signNum) {
          _drawText(
            canvas,
            '1',
            Offset(x, y - cellSize / 3 + 20),
            10,
            AppTheme.error,
          );
        }
      }
    }
  }

  void _drawSouthIndianPlanets(Canvas canvas, double padding, double cellSize) {
    for (final position in chart.positions) {
      if (position.planet == PlanetType.ascendant) continue;

      // Find cell for this sign
      final signIndex = position.sign.index; // 0-11
      
      // Map sign index to row/col (South Indian layout)
      int row, col;
      if (signIndex >= 10) { // Pisces (11), Aries (0)
        row = 0;
        col = signIndex == 11 ? 1 : 2;
      } else if (signIndex <= 2) { // Taurus (1), Gemini (2)
        row = 0;
        col = signIndex + 2;
      } else if (signIndex == 9) { // Aquarius (10)
        row = 1;
        col = 0;
      } else if (signIndex == 3) { // Cancer (3)
        row = 1;
        col = 3;
      } else if (signIndex == 8) { // Capricorn (9)
        row = 2;
        col = 0;
      } else if (signIndex == 4) { // Leo (4)
        row = 2;
        col = 3;
      } else { // Sagittarius (8) to Virgo (5)
        row = 3;
        col = 11 - signIndex;
      }

      final x = padding + col * cellSize + cellSize / 2;
      final y = padding + row * cellSize + cellSize / 2;

      _drawPlanetSymbol(canvas, position.planet, Offset(x, y + 10), position.isRetrograde);
    }
  }

  void _drawPlanetsInCell(Canvas canvas, List<PlanetPosition> planets, Offset center, double cellSize) {
    if (planets.isEmpty) return;

    final startY = center.dy - (planets.length * 10) / 2;
    for (int i = 0; i < planets.length; i++) {
      final y = startY + i * 18;
      _drawPlanetSymbol(canvas, planets[i].planet, Offset(center.dx, y), planets[i].isRetrograde);
    }
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
    _drawText(canvas, text, position, 14, AppTheme.textMain);

    if (retrograde) {
      _drawText(
        canvas,
        '℞',
        Offset(position.dx + 8, position.dy - 6),
        7,
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