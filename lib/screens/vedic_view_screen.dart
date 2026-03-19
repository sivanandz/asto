import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class VedicViewScreen extends StatelessWidget {
  const VedicViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vedic Mode'.toUpperCase(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, letterSpacing: -1.0),
          ),
          const SizedBox(height: 8),
          Text(
            'Lagna Chart (D1) • Sidereal Zodiac • Lahiri Ayanamsa',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 24),

          // Toggle Style Button Group
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                  child: const Text('North Indian'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textMuted,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                  child: const Text('South Indian'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // North Indian Chart
          _buildChartContainer(
            context,
            title: 'North Indian Style (Diamond)',
            badgeColor: AppTheme.primary,
            icon: Symbols.brightness_7,
            child: _buildNorthIndianChart(),
          ),
          const SizedBox(height: 32),

          // South Indian Chart
          _buildChartContainer(
            context,
            title: 'South Indian Style (Square)',
            badgeColor: const Color(0xFF5A805B),
            icon: Symbols.wb_sunny,
            child: _buildSouthIndianChart(),
          ),
          const SizedBox(height: 48),

          // Planetary Positions Table
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.borderColor),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: AppTheme.borderColor.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Planetary Positions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                      Text('DOWNLOAD PDF', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.primary, letterSpacing: 1.5)),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.textMuted, letterSpacing: 1.5),
                    dataTextStyle: Theme.of(context).textTheme.bodyMedium,
                    columns: const [
                      DataColumn(label: Text('PLANET')),
                      DataColumn(label: Text('RASI')),
                      DataColumn(label: Text('DEGREE')),
                      DataColumn(label: Text('NAKSHATRA')),
                      DataColumn(label: Text('PADA')),
                      DataColumn(label: Text('STATUS')),
                    ],
                    rows: [
                      _buildTableRow('Ascendant (Lagna)', 'Aries', "14° 22'", 'Bharani', '1', '-'),
                      _buildTableRow('Sun', 'Aries', "27° 10'", 'Krittika', '1', 'Exalted', statusColor: AppTheme.tertiary),
                      _buildTableRow('Moon', 'Leo', "05° 44'", 'Magha', '2', 'Neutral'),
                      _buildTableRow('Mars', 'Capricorn', "12° 15'", 'Shravana', '1', 'Exalted', statusColor: AppTheme.tertiary),
                      _buildTableRow('Saturn', 'Libra', "19° 30'", 'Swati', '4', 'Retrograde', statusColor: AppTheme.error),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(BuildContext context, {required String title, required Color badgeColor, required IconData icon, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 16,
            child: Icon(icon, size: 120, color: AppTheme.textMuted.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0)),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.borderColor.withOpacity(0.5))),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNorthIndianChart() {
    return CustomPaint(
      painter: _NorthIndianChartPainter(),
      child: const Stack(
        children: [
          // Basic manual placement for demo purposes matching the HTML layout
          Positioned(top: 80, left: 0, right: 0, child: Text('1', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18))),
          Positioned(top: 110, left: 0, right: 0, child: Text('Me, Su', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMain, fontSize: 12))),

          Positioned(top: 30, left: 80, child: Text('2', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Positioned(top: 80, left: 30, child: Text('3', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),

          Positioned(top: 180, left: 80, child: Text('4', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18))),
          Positioned(top: 210, left: 60, child: Text('Mo, Ju', style: TextStyle(color: AppTheme.textMain, fontSize: 12))),

          Positioned(bottom: 80, left: 30, child: Text('5', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Positioned(bottom: 30, left: 80, child: Text('6', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),

          Positioned(bottom: 60, left: 0, right: 0, child: Text('7', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18))),
          Positioned(bottom: 30, left: 0, right: 0, child: Text('Sa (R)', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMain, fontSize: 12))),

          Positioned(bottom: 30, right: 80, child: Text('8', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Positioned(bottom: 80, right: 30, child: Text('9', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),

          Positioned(top: 180, right: 80, child: Text('10', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18))),
          Positioned(top: 210, right: 60, child: Text('Ma, Ve', style: TextStyle(color: AppTheme.textMain, fontSize: 12))),

          Positioned(top: 80, right: 30, child: Text('11', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
          Positioned(top: 30, right: 80, child: Text('12', style: TextStyle(color: AppTheme.textMuted, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildSouthIndianChart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final cellW = w / 4;
        final cellH = h / 4;

        return Stack(
          children: [
            // Center area
            Positioned(
              left: cellW, top: cellH, width: cellW * 2, height: cellH * 2,
              child: Container(
                color: AppTheme.surfaceContainerLowest.withOpacity(0.5),
                decoration: BoxDecoration(border: Border.all(color: AppTheme.borderColor.withOpacity(0.5))),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('LAGNA', style: TextStyle(color: AppTheme.primary, fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Public Sans')),
                    Text('Ascendant in Aries', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ),

            // Outer Cells (12 signs)
            _buildSouthIndianCell(0, 0, cellW, cellH, 'PIS', ''),
            _buildSouthIndianCell(1, 0, cellW, cellH, 'ARI', 'Me Su', highlight: true),
            _buildSouthIndianCell(2, 0, cellW, cellH, 'TAU', ''),
            _buildSouthIndianCell(3, 0, cellW, cellH, 'GEM', ''),

            _buildSouthIndianCell(0, 1, cellW, cellH, 'AQU', 'Ra'),
            _buildSouthIndianCell(3, 1, cellW, cellH, 'CAN', ''),

            _buildSouthIndianCell(0, 2, cellW, cellH, 'CAP', 'Ma Ve', highlight: true),
            _buildSouthIndianCell(3, 2, cellW, cellH, 'LEO', 'Mo Ju'),

            _buildSouthIndianCell(0, 3, cellW, cellH, 'SAG', ''),
            _buildSouthIndianCell(1, 3, cellW, cellH, 'SCO', 'Ke'),
            _buildSouthIndianCell(2, 3, cellW, cellH, 'LIB', 'Sa (R)'),
            _buildSouthIndianCell(3, 3, cellW, cellH, 'VIR', ''),
          ],
        );
      }
    );
  }

  Widget _buildSouthIndianCell(int col, int row, double w, double h, String sign, String planets, {bool highlight = false}) {
    return Positioned(
      left: col * w,
      top: row * h,
      width: w,
      height: h,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: AppTheme.borderColor.withOpacity(0.5))),
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(sign, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.bold)),
            if (planets.isNotEmpty)
              Text(planets, style: TextStyle(fontSize: 12, color: highlight ? AppTheme.primary : AppTheme.textMain, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  DataRow _buildTableRow(String planet, String rasi, String degree, String nakshatra, String pada, String status, {Color statusColor = AppTheme.textMain}) {
    return DataRow(
      cells: [
        DataCell(Text(planet, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain))),
        DataCell(Text(rasi, style: const TextStyle(color: AppTheme.primary))),
        DataCell(Text(degree, style: const TextStyle(fontFamily: 'monospace'))),
        DataCell(Text(nakshatra)),
        DataCell(Text(pada)),
        DataCell(Text(status, style: TextStyle(color: statusColor))),
      ]
    );
  }
}

class _NorthIndianChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.borderColor.withOpacity(0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Outer box
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Cross diagonals
    canvas.drawLine(const Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(w, 0), Offset(0, h), paint);

    // Diamond
    final path = Path()
      ..moveTo(w / 2, 0)
      ..lineTo(w, h / 2)
      ..lineTo(w / 2, h)
      ..lineTo(0, h / 2)
      ..close();

    paint.strokeWidth = 2.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
