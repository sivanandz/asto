import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/tarot_card.dart';
import '../providers/app_provider.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final _questionController = TextEditingController();
  TarotReading? _currentReading;
  bool _isDrawing = false;
  bool _showCards = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _drawCards() async {
    final question = _questionController.text.trim().isEmpty
        ? 'What do the cards reveal?'
        : _questionController.text.trim();

    setState(() {
      _isDrawing = true;
      _showCards = false;
      _currentReading = null;
    });

    // Simulate card drawing animation delay
    await Future.delayed(const Duration(seconds: 2));

    final provider = context.read<AppProvider>();
    final reading = await provider.drawTarotCards(question);

    if (mounted) {
      setState(() {
        _currentReading = reading;
        _isDrawing = false;
        _showCards = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeroSection(context),
          const SizedBox(height: 32),
          _buildQuestionInput(context),
          const SizedBox(height: 48),
          _buildCardsDisplay(),
          const SizedBox(height: 48),
          _buildActionButtons(context),
          const SizedBox(height: 48),
          _buildRecentReadingsSection(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Symbols.stars,
                color: AppTheme.primary,
                fill: 1.0,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'DAILY TAROT SPREAD',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  letterSpacing: 2.0,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Past, Present, & Future',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(fontSize: 48, letterSpacing: -2.0),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Focus on a specific question or your current energy. Let the obsidian deck reveal the unseen paths before you.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMuted,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _questionController,
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'Enter your question (optional)...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textMuted.withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9999),
            borderSide: const BorderSide(color: AppTheme.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCardsDisplay() {
    if (_isDrawing) {
      return _buildShufflingAnimation();
    } else if (_showCards && _currentReading != null) {
      return _buildCardSpread();
    } else {
      return _buildPlaceholderCards();
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _isDrawing ? null : _drawCards,
          icon: _isDrawing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : const Icon(Symbols.auto_awesome),
          label: Text(_isDrawing ? 'Drawing...' : 'Draw Cards'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.textMain,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if (_currentReading != null)
          OutlinedButton.icon(
            onPressed: () => _showInterpretation(context),
            icon: const Icon(Symbols.visibility),
            label: const Text('View Reading'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textMain,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: Theme.of(context).textTheme.titleMedium,
              side: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentReadingsSection(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final readings = provider.tarotReadings;
        if (readings.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Readings',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 16),
            ...readings
                .take(3)
                .map((reading) => _buildReadingCard(context, reading)),
          ],
        );
      },
    );
  }

  Widget _buildShufflingAnimation() {
    return Column(
      children: [
        const SizedBox(
          width: 120,
          height: 180,
          child: CardShufflingAnimation(),
        ),
        const SizedBox(height: 24),
        Text(
          'Shuffling the deck...',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cards = [
          _buildEmptyCardSlot(context, 'Past', Symbols.history),
          _buildEmptyCardSlot(context, 'Present', Symbols.visibility),
          _buildEmptyCardSlot(context, 'Future', Symbols.auto_awesome),
        ];

        if (isWide) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: c,
                  ),
                )
                .toList(),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildEmptyCardSlot(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 160,
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor, width: 2),
          ),
          child: Center(
            child: Icon(
              icon,
              color: AppTheme.textMuted.withOpacity(0.3),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildCardSpread() {
    final draws = _currentReading!.draws;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cards = draws.asMap().entries.map((entry) {
          return _buildTarotCard(context, entry.value, entry.key);
        }).toList();

        if (isWide) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: c,
                  ),
                )
                .toList(),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildTarotCard(BuildContext context, TarotDraw draw, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 200),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Column(
        children: [
          FlipCard(
            front: _buildCardBack(),
            back: _buildCardFront(draw.card, draw.position),
            flipOnTap: true,
          ),
          const SizedBox(height: 12),
          Text(
            draw.positionName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            draw.card.displayName,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (draw.position == TarotPosition.reversed)
            Text(
              'Reversed',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppTheme.error),
            ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 100,
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E201D), Color(0xFF0C0F0C)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Center(
        child: Icon(
          Symbols.auto_awesome,
          color: AppTheme.primary.withOpacity(0.5),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildCardFront(TarotCard card, TarotPosition position) {
    final isReversed = position == TarotPosition.reversed;

    return Transform.rotate(
      angle: isReversed ? 3.14159 : 0,
      child: Container(
        width: 100,
        height: 160,
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primary, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(card.suitSymbol, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              card.romanNumeral,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                card.displayName.split(' ').last,
                style: const TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(BuildContext context, TarotReading reading) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          reading.question,
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${reading.draws.length} cards • ${_formatDate(reading.createdAt)}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: reading.draws.map((d) => Text(d.card.suitSymbol)).toList(),
        ),
        onTap: () {
          setState(() {
            _currentReading = reading;
            _showCards = true;
          });
        },
      ),
    );
  }

  void _showInterpretation(BuildContext context) {
    if (_currentReading == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your Reading',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _currentReading!.question,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted),
                ),
                const SizedBox(height: 24),
                ..._currentReading!.draws.asMap().entries.map((entry) {
                  final draw = entry.value;
                  return _buildInterpretationCard(context, draw);
                }),
                const SizedBox(height: 24),
                if (_currentReading!.interpretation != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: Text(
                      _currentReading!.interpretation!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInterpretationCard(BuildContext context, TarotDraw draw) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                draw.positionName,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                draw.card.displayName,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (draw.position == TarotPosition.reversed)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Reversed',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppTheme.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            draw.meaning,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 8),
          Text(
            'Keywords: ${draw.card.keywords}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppTheme.primary),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Flip Card Widget
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool flipOnTap;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.flipOnTap = true,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFlipped) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flipOnTap ? _flip : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14159;
          final isFront = angle < 1.5708;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFront
                ? widget.front
                : Transform(
                    transform: Matrix4.identity()..rotateY(3.14159),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}

// Card Shuffling Animation
class CardShufflingAnimation extends StatefulWidget {
  const CardShufflingAnimation({super.key});

  @override
  State<CardShufflingAnimation> createState() => _CardShufflingAnimationState();
}

class _CardShufflingAnimationState extends State<CardShufflingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: _controller.value * 0.5 - 0.25,
              child: _buildCard(AppTheme.surfaceContainerLow),
            ),
            Transform.translate(
              offset: Offset(math.sin(_controller.value * 3.14159 * 2) * 10, 0),
              child: _buildCard(AppTheme.surfaceContainer),
            ),
            Transform.rotate(
              angle: -_controller.value * 0.5 + 0.25,
              child: _buildCard(AppTheme.surfaceContainerLowest),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(Color color) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Center(
        child: Icon(
          Symbols.auto_awesome,
          color: AppTheme.primary.withOpacity(0.5),
          size: 24,
        ),
      ),
    );
  }
}
