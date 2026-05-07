import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/app_provider.dart';
import '../components/vedic_chart_widget.dart';
import '../models/birth_chart.dart';
import '../models/planet_position.dart';

class VedicViewScreen extends StatefulWidget {
  const VedicViewScreen({super.key});

  @override
  State<VedicViewScreen> createState() => _VedicViewScreenState();
}

class _VedicViewScreenState extends State<VedicViewScreen> {
  VedicChartStyle? _localStyle;

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
              const SizedBox(height: 24),
              _buildStyleToggle(context),
              const SizedBox(height: 48),
              _buildChartDisplay(context, chart),
              const SizedBox(height: 48),
              _buildPlanetaryTable(context, chart),
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
          Icon(Symbols.brightness_7, size: 64, color: AppTheme.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No Vedic Chart Available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a Vedic chart in settings to view it here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to settings
            },
            icon: const Icon(Symbols.settings),
            label: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user, dynamic chart) {
    final ayanamsaName = chart.ayanamsa?.name ?? 'Lahiri';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vedic Mode'.toUpperCase(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, letterSpacing: -1.0),
        ),
        const SizedBox(height: 8),
        Text(
          'Lagna Chart (D1) • Sidereal Zodiac • ${ayanamsaName.capitalize()} Ayanamsa',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStyleToggle(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final selectedStyle = _localStyle ?? provider.vedicChartStyle;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: 'North Indian',
            isSelected: selectedStyle == VedicChartStyle.northIndian,
            onPressed: () => setState(() => _localStyle = VedicChartStyle.northIndian),
          ),
          _buildToggleButton(
            label: 'South Indian',
            isSelected: selectedStyle == VedicChartStyle.southIndian,
            onPressed: () => setState(() => _localStyle = VedicChartStyle.southIndian),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppTheme.primary : Colors.transparent,
        foregroundColor: isSelected ? AppTheme.onPrimary : AppTheme.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        elevation: 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildChartDisplay(BuildContext context, dynamic chart) {
    final provider = context.watch<AppProvider>();
    final selectedStyle = _localStyle ?? provider.vedicChartStyle;

    final styleName = selectedStyle == VedicChartStyle.northIndian
        ? 'North Indian Style (Diamond)'
        : 'South Indian Style (Square)';
    final badgeColor = selectedStyle == VedicChartStyle.northIndian
        ? AppTheme.primary
        : const Color(0xFF5A805B);
    final icon = selectedStyle == VedicChartStyle.northIndian
        ? Symbols.brightness_7
        : Symbols.wb_sunny;

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
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      styleName.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 2.0),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: VedicChartWidget(
                        chart: chart,
                        style: selectedStyle,
                        size: 400,
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

  Widget _buildPlanetaryTable(BuildContext context, dynamic chart) {
    final positions = chart.positions.toList()
      ..sort((a, b) => a.planet.index.compareTo(b.planet.index));

    return Container(
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
                Text(
                  'Planetary Positions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                Text(
                  'DOWNLOAD PDF',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.primary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingTextStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textMuted,
                letterSpacing: 1.5,
              ),
              dataTextStyle: Theme.of(context).textTheme.bodyMedium,
              columns: const [
                DataColumn(label: Text('PLANET')),
                DataColumn(label: Text('RASI')),
                DataColumn(label: Text('DEGREE')),
                DataColumn(label: Text('HOUSE')),
                DataColumn(label: Text('STATUS')),
              ],
              rows: positions.where((p) => p.planet != PlanetType.ascendant).map((p) {
                return _buildTableRow(p);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildTableRow(PlanetPosition position) {
    final status = _getPlanetStatus(position);
    final statusColor = _getStatusColor(status);

    return DataRow(
      cells: [
        DataCell(Text(
          position.planet.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain),
        )),
        DataCell(Text(
          position.sign.name.capitalize(),
          style: const TextStyle(color: AppTheme.primary),
        )),
        DataCell(Text(
          "${position.degree.toStringAsFixed(1)}°",
          style: const TextStyle(fontFamily: 'monospace'),
        )),
        DataCell(Text('${position.house}')),
        DataCell(Text(
          status,
          style: TextStyle(color: statusColor),
        )),
      ],
    );
  }

  String _getPlanetStatus(PlanetPosition position) {
    if (position.isRetrograde) return 'Retrograde';

    // Simplified dignity logic
    final exalted = {
      PlanetType.sun: ZodiacSign.aries,
      PlanetType.moon: ZodiacSign.taurus,
      PlanetType.mars: ZodiacSign.capricorn,
      PlanetType.mercury: ZodiacSign.virgo,
      PlanetType.jupiter: ZodiacSign.cancer,
      PlanetType.venus: ZodiacSign.pisces,
      PlanetType.saturn: ZodiacSign.libra,
    };

    if (exalted[position.planet] == position.sign) return 'Exalted';

    // Debilitated positions
    final debilitated = {
      PlanetType.sun: ZodiacSign.libra,
      PlanetType.moon: ZodiacSign.scorpio,
      PlanetType.mars: ZodiacSign.cancer,
      PlanetType.mercury: ZodiacSign.pisces,
      PlanetType.jupiter: ZodiacSign.capricorn,
      PlanetType.venus: ZodiacSign.virgo,
      PlanetType.saturn: ZodiacSign.aries,
    };

    if (debilitated[position.planet] == position.sign) return 'Debilitated';

    return 'Normal';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Exalted':
        return AppTheme.tertiary;
      case 'Debilitated':
        return AppTheme.error;
      case 'Retrograde':
        return AppTheme.error;
      default:
        return AppTheme.textMain;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
