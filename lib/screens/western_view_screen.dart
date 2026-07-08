import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/app_provider.dart';
import '../components/western_chart_widget.dart';
import '../models/planet_position.dart';

class WesternViewScreen extends StatelessWidget {
  const WesternViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        final user = provider.currentUser;
        final chart = provider.currentChart;

        if (user == null || chart == null) {
          return _buildNoDataView(context);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user, chart),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  final child = isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 8, child: _buildAstroWheel(context, chart)),
                            const SizedBox(width: 32),
                            Expanded(flex: 4, child: _buildRightColumn(context, provider)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildAstroWheel(context, chart),
                            const SizedBox(height: 32),
                            _buildRightColumn(context, provider),
                          ],
                        );
                  return child;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoDataView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Symbols.auto_graph, size: 64, color: AppTheme.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No Chart Data Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete the onboarding to generate your chart',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to onboarding
            },
            icon: const Icon(Symbols.person),
            label: const Text('Set Up Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user, dynamic chart) {
    final dateStr = '${user.birthDate.day} ${_monthName(user.birthDate.month)} ${user.birthDate.year}';
    final timeStr = '${user.birthDate.hour.toString().padLeft(2, '0')}:${user.birthDate.minute.toString().padLeft(2, '0')}';
    final locationStr = user.birthPlace;

    return Row(
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
                '${user.name.toUpperCase()} • $dateStr • $timeStr • ${locationStr.toUpperCase()}',
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
    );
  }

  Widget _buildAstroWheel(BuildContext context, dynamic chart) {
    final ascendant = chart.ascendant;
    final ascendantText = ascendant != null
        ? '${ascendant.sign.name.toUpperCase()} ${ascendant.degree.toStringAsFixed(0)}°'
        : 'Unknown';

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
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    WesternChartWidget(chart: chart, size: 600),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ASCENDANT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.primary,
                              letterSpacing: 3.0,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ascendantText,
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
          _buildPlanetIndicators(chart),
        ],
      ),
    );
  }

  Widget _buildPlanetIndicators(dynamic chart) {
    final planets = [
      _PlanetIndicator(Symbols.wb_sunny, AppTheme.primary, chart.sun, 'SUN'),
      _PlanetIndicator(Symbols.nights_stay, AppTheme.tertiary, chart.moon, 'MOON'),
      _PlanetIndicator(Symbols.brightness_7, AppTheme.error, chart.mars, 'MARS'),
      _PlanetIndicator(Symbols.star, const Color(0xFFFFD700), chart.jupiter, 'JUPITER'),
      _PlanetIndicator(Symbols.schedule, AppTheme.textMuted, chart.saturn, 'SATURN'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: planets.where((p) => p.position != null).map((p) {
        return _buildZodiacIndicator(
          p.icon,
          p.color,
          '${p.label} ${p.position!.sign.name.toUpperCase()} ${p.position!.degree.toStringAsFixed(0)}°',
        );
      }).toList(),
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
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Manrope',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, AppProvider provider) {
    return Column(
      children: [
        _buildPlanetsList(context, provider),
        const SizedBox(height: 24),
        _buildHousesList(context, provider),
        const SizedBox(height: 24),
        _buildInsight(context, provider),
      ],
    );
  }

  Widget _buildPlanetsList(BuildContext context, AppProvider provider) {
    final chart = provider.currentChart;
    if (chart == null) return const SizedBox.shrink();

    final positions = chart.positions
        .where((p) => p.planet != PlanetType.ascendant)
        .toList();

    return Container(
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
            child: Text(
              'PLANETARY POSITIONS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
            ),
          ),
          const Divider(height: 1),
          ...positions.take(6).map((p) {
            return Column(
              children: [
                _buildPlanetRow(context, p),
                const Divider(height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlanetRow(BuildContext context, PlanetPosition position) {
    // ⚡ Bolt: Use const for static maps in build methods to prevent memory reallocation on every rebuild.
    const planetSymbols = {
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text(
            planetSymbols[position.planet] ?? '•',
            style: const TextStyle(fontSize: 18, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.planet.displayName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14),
                ),
                Text(
                  'House ${position.house}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '${position.sign.name.toUpperCase()} ${position.degree.toStringAsFixed(1)}°',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          if (position.isRetrograde)
            const Text(
              ' ℞',
              style: TextStyle(fontSize: 10, color: AppTheme.error),
            ),
        ],
      ),
    );
  }

  Widget _buildHousesList(BuildContext context, AppProvider provider) {
    final chart = provider.currentChart;
    if (chart == null) return const SizedBox.shrink();

    // Calculate planet count per house
    final houseCounts = <int, int>{};
    for (final pos in chart.positions) {
      if (pos.planet != PlanetType.ascendant) {
        houseCounts[pos.house] = (houseCounts[pos.house] ?? 0) + 1;
      }
    }

    // Get top 3 houses with most planets
    final sortedHouses = houseCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topHouses = sortedHouses.take(3).toList();

    if (topHouses.isEmpty) return const SizedBox.shrink();

    final total = houseCounts.values.fold(0, (a, b) => a + b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DOMINANT HOUSES',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
          ),
          const SizedBox(height: 24),
          ...topHouses.map((h) {
            final houseName = _houseName(h.key);
            final value = h.value / (total > 0 ? total : 1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildHouseProgressBar(
                '${h.key}${_ordinal(h.key)} House ($houseName)',
                value,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHouseProgressBar(String label, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMuted,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppTheme.borderColor.withOpacity(0.5),
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildInsight(BuildContext context, AppProvider provider) {
    final sun = provider.sun;
    final moon = provider.moon;
    final rising = provider.risingSign;

    if (sun == null || moon == null) return const SizedBox.shrink();

    return Container(
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
                Text(
                  'Your Cosmic Signature',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.textMain),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sun in ${sun.sign.name} shapes your core identity, Moon in ${moon.sign.name} guides your emotional nature, and ${rising.isNotEmpty ? '$rising rising' : 'your ascendant'} colors how others perceive you.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = ['', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month];
  }

  String _houseName(int house) {
    const names = [
      '', 'Self', 'Values', 'Communication', 'Home', 'Creativity',
      'Health', 'Partnership', 'Transformation', 'Philosophy', 'Career',
      'Community', 'Spirituality'
    ];
    return names[house];
  }

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return 'th';
    switch (n % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}

class _PlanetIndicator {
  final IconData icon;
  final Color color;
  final PlanetPosition? position;
  final String label;

  _PlanetIndicator(this.icon, this.color, this.position, this.label);
}
