import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.6),
            radius: 1.0,
            colors: [Color(0xFF083250), Color(0xFF09090B)],
            stops: [0.0, 0.7],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Initialize Your Soul Map',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 36, letterSpacing: -1.0),
            ),
            const SizedBox(height: 8),
            Text(
              'Precision is required for the celestial alignment. Enter your birth parameters below.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E201D).withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.borderColor),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 48, height: 4, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Container(width: 48, height: 4, decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Container(width: 48, height: 4, decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 16),
                      Text('STEP 1 OF 3', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildInput(context, 'FULL NAME', 'e.g. Orion Vance'),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: _buildInput(context, 'BIRTH DATE', 'MM/DD/YYYY', icon: Symbols.calendar_today)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildInput(context, 'EXACT TIME', 'HH:MM AM', icon: Symbols.schedule)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInput(context, 'BIRTH LOCATION', 'Search city or coordinates', icon: Symbols.location_on),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Symbols.arrow_forward),
                      label: const Text('Generate Cosmic Profile'),
                      iconAlignment: IconAlignment.end,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E201D).withOpacity(0.4),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.borderColor),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  SizedBox(
                    height: 256,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: AppTheme.surfaceContainerLowest),
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAYyZJdmIlxfUZFooyCvQUkfoChsO-ibACHNBRSnfZIh8GnnK0lz82IExnJy_S_VFk_kdT2qjhErRd8noNnXQuVYzuoHy3DwPpYhjjA8C2QgB22CkYwteDGeJqNmiX2SkwIUQxd98USoFtLleg7d8se85uh4-XB77jaqh0v2IEKGTM-61mSAoCXOQm2YhIvyAJrBd1gD21SgjbR_0W3e1hpCJ2DvaMM38yFeh-sn7tTvP9UfA8Jh-c1O1yWy4Hwdyw34hSO0yhegN8',
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.overlay,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [AppTheme.surfaceContainer, Colors.transparent],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STATUS: AWAITING DATA',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.primary, fontSize: 10, letterSpacing: 3.0),
                                  ),
                                  Text(
                                    'Unknown Aspect',
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainer,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.borderColor),
                                ),
                                child: const Icon(Symbols.flare, color: AppTheme.primary, size: 32),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(9999),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Symbols.auto_graph, color: AppTheme.primary, size: 16),
                              ),
                              const SizedBox(width: 16),
                              Text('Natal chart precision: 0.00%', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your natal chart is a screenshot of the heavens at the exact moment of your arrival. We use Swiss Ephemeris data for millisecond accuracy.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInfoCard(context, Symbols.security, 'Encrypted', 'Soul-bound data')),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoCard(context, Symbols.public, 'Vedic+', 'Multi-System support')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(BuildContext context, String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: 1.5)),
        ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: icon != null ? Icon(icon, color: AppTheme.textMuted) : null,
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E201D).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 14)),
          Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, letterSpacing: 1.0)),
        ],
      ),
    );
  }
}
