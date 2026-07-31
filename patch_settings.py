import re

with open('lib/screens/settings_screen.dart', 'r') as f:
    content = f.read()

# Add VedicChartStyle import if missing
if "import '../components/vedic_chart_widget.dart';" not in content:
    content = content.replace("import '../database/database_helper.dart';", "import '../database/database_helper.dart';\nimport '../components/vedic_chart_widget.dart';")

# Update _buildChartStyleSelector
old_selector = """  Widget _buildChartStyleSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Symbols.grid_view, color: AppTheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default Vedic Chart Style',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Preferred visualization for Vedic charts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('North Indian'),
            subtitle: const Text('Diamond-style chart'),
            trailing: const Icon(Icons.check, color: AppTheme.primary),
            onTap: () {
              // TODO: Set preference
            },
          ),
          ListTile(
            title: const Text('South Indian'),
            subtitle: const Text('Square-style chart'),
            trailing: const Icon(Icons.radio_button_unchecked, color: AppTheme.textMuted),
            onTap: () {
              // TODO: Set preference
            },
          ),
        ],
      ),
    );
  }"""

new_selector = """  Widget _buildChartStyleSelector(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final isNorthIndian = provider.vedicChartStyle == VedicChartStyle.northIndian;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Symbols.grid_view, color: AppTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Vedic Chart Style',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Preferred visualization for Vedic charts',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                title: const Text('North Indian'),
                subtitle: const Text('Diamond-style chart'),
                trailing: Icon(
                  isNorthIndian ? Icons.check : Icons.radio_button_unchecked,
                  color: isNorthIndian ? AppTheme.primary : AppTheme.textMuted,
                ),
                onTap: () {
                  provider.setVedicChartStyle(VedicChartStyle.northIndian);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('North Indian style selected'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('South Indian'),
                subtitle: const Text('Square-style chart'),
                trailing: Icon(
                  !isNorthIndian ? Icons.check : Icons.radio_button_unchecked,
                  color: !isNorthIndian ? AppTheme.primary : AppTheme.textMuted,
                ),
                onTap: () {
                  provider.setVedicChartStyle(VedicChartStyle.southIndian);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('South Indian style selected'),
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }"""

if old_selector in content:
    content = content.replace(old_selector, new_selector)

with open('lib/screens/settings_screen.dart', 'w') as f:
    f.write(content)
