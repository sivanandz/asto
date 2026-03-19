import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';
import 'dart:math' as math;

class WesternViewScreen extends StatelessWidget {
  const WesternViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Western Natal Chart',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 32, letterSpacing: -1.0),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'JOHN DOE • 14 MAR 1992 • 10:45 AM • LONDON, UK',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.share, size: 16),
                    label: const Text('Export'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textMain,
                      side: const BorderSide(color: AppTheme.borderColor),
                      backgroundColor: const Color(0xFF27272A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Symbols.settings, size: 16),
                    label: const Text('Adjust'),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),

          // Main layout grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              final child = isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: _buildAstroWheel(context)),
                        const SizedBox(width: 32),
                        Expanded(flex: 4, child: _buildRightColumn(context)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildAstroWheel(context),
                        const SizedBox(height: 32),
                        _buildRightColumn(context),
                      ],
                    );
              return child;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAstroWheel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
        gradient: RadialGradient(
          colors: [AppTheme.primary.withOpacity(0.05), Colors.transparent],
          stops: const [0.0, 0.7],
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          // SVG representation placeholder using CustomPaint
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: _AstroWheelPainter(),
                      size: Size.infinite,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ASCENDANT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.primary, letterSpacing: 3.0, fontSize: 10),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GEMINI 12°',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildZodiacIndicator(Symbols.wb_sunny, AppTheme.primary, 'SUN PISCES 24°'),
              _buildZodiacIndicator(Symbols.nights_stay, AppTheme.tertiary, 'MOON SCORPIO 11°'),
              _buildZodiacIndicator(Symbols.brightness_7, AppTheme.error, 'MARS CANCER 02°'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildZodiacIndicator(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Manrope')),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context) {
    return Column(
      children: [
        // Major Aspects List
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: AppTheme.surfaceContainerLow,
                width: double.infinity,
                child: Text('MAJOR ASPECTS', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0)),
              ),
              const Divider(height: 1),
              _buildAspectRow(context, Symbols.change_history, AppTheme.primary, 'Sun Trine Moon', "0° 42' • Harmonic"),
              const Divider(height: 1),
              _buildAspectRow(context, Symbols.square, AppTheme.error, 'Mars Square Venus', "2° 15' • Tensional"),
              const Divider(height: 1),
              _buildAspectRow(context, Symbols.remove, AppTheme.tertiary, 'Saturn Opposition Pluto', "4° 02' • Critical"),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // House Placements
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainer,
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('DOMINANT HOUSES', style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0)),
              const SizedBox(height: 24),
              _buildHouseProgressBar('10th House (Career)', 0.42),
              const SizedBox(height: 16),
              _buildHouseProgressBar('1st House (Identity)', 0.28),
              const SizedBox(height: 16),
              _buildHouseProgressBar('7th House (Relat.)', 0.15),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Insight
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Symbols.auto_awesome, color: AppTheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Astro Insight', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.textMain)),
                    const SizedBox(height: 8),
                    Text(
                      'Your chart shows a powerful Grand Trine in water signs, indicating high emotional intelligence and intuitive depth in professional spheres.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAspectRow(BuildContext context, IconData icon, Color color, String title, String subtitle) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14)),
                  Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: 1.0)),
                ],
              ),
            ),
            const Icon(Symbols.chevron_right, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseProgressBar(String label, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textMuted)),
            Text('${(value * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: AppTheme.borderColor,
          color: AppTheme.primary,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }
}

class _AstroWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rOuter = size.width / 2.1;
    final rInner = size.width / 2.5;

    final paint = Paint()
      ..color = AppTheme.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(Offset(cx, cy), rOuter, paint);
    canvas.drawCircle(Offset(cx, cy), rInner, paint);

    // Divisions
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final x1 = cx + rInner * math.cos(angle);
      final y1 = cy + rInner * math.sin(angle);
      final x2 = cx + rOuter * math.cos(angle);
      final y2 = cy + rOuter * math.sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint..strokeWidth = 0.5);
    }

    // Aspects (Lines connecting inner parts)
    final pTrine = Paint()..color = AppTheme.primary..strokeWidth = 1.5;
    final pSquare = Paint()..color = AppTheme.error..strokeWidth = 1.5;

    // Trine coordinates (triangle)
    final t1 = Offset(cx, cy - rInner + 10);
    final t2 = Offset(cx + (rInner - 10) * math.cos(30 * math.pi / 180), cy + (rInner - 10) * math.sin(30 * math.pi / 180));
    final t3 = Offset(cx - (rInner - 10) * math.cos(30 * math.pi / 180), cy + (rInner - 10) * math.sin(30 * math.pi / 180));

    canvas.drawLine(t1, t2, pTrine);
    canvas.drawLine(t2, t3, pTrine);
    canvas.drawLine(t3, t1, pTrine);

    // Square coordinates
    final s1 = Offset(cx, cy - rInner + 10);
    final s2 = Offset(cx + rInner - 10, cy);
    final s3 = Offset(cx, cy + rInner - 10);
    final s4 = Offset(cx - rInner + 10, cy);

    canvas.drawLine(s1, s2, pSquare);
    canvas.drawLine(s2, s3, pSquare);
    canvas.drawLine(s3, s4, pSquare);
    canvas.drawLine(s4, s1, pSquare);

    // Opposition
    final pOpp = Paint()..color = AppTheme.tertiaryContainer..strokeWidth = 2.0..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - rInner + 10), Offset(cx, cy + rInner - 10), pOpp);

    // Planets (Dots)
    final pDot = Paint()..color = AppTheme.textMain..style = PaintingStyle.fill;
    canvas.drawCircle(t1, 4, pDot);
    canvas.drawCircle(t2, 4, pDot);
    canvas.drawCircle(t3, 4, pDot);
    canvas.drawCircle(s2, 4, pDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
