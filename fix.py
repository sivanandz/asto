import re
with open('/app/lib/screens/tarot_screen.dart', 'r') as f:
    code = f.read()

replacement = """              final bentoItem1 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Symbols.nights_stay, color: AppTheme.tertiary),
                        const SizedBox(width: 12),
                        Text('Lunar Phase', style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Waxing Gibbous in Scorpio. Deep emotional insights are more accessible. Focus on internal transformation.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );

              final bentoItem2 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('78', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 36, color: AppTheme.primary)),
                    const SizedBox(height: 4),
                    Text('CARDS IN DECK', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: -0.5)),
                  ],
                ),
              );

              final bentoItem3 = Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Symbols.auto_fix_high, size: 36, color: AppTheme.tertiary),
                    const SizedBox(height: 4),
                    Text('ZENITH MODE', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: -0.5)),
                  ],
                ),
              );

              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 2, child: bentoItem1),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: bentoItem2),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: bentoItem3),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    bentoItem1,
                    const SizedBox(height: 16),
                    bentoItem2,
                    const SizedBox(height: 16),
                    bentoItem3,
                  ],
                );
              }
            },
"""

start_idx = code.find('              final bentoItem1 =')
end_idx = code.find('            },', start_idx) + len('            },\n')

with open('/app/lib/screens/tarot_screen.dart', 'w') as f:
    f.write(code[:start_idx] + replacement + code[end_idx:])
