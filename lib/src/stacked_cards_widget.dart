/*────────────────────────── main.dart ──────────────────────────*/
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      // ① No colour – auto pastel


      CardItem(
        title: const Text('Travel Tips'),
        body: const Text(
          'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.',
        ),
      ),

      // ② Solid colour
      CardItem(
        title: const Text('Health & Wellness'),
        body: const Text(
          'Explore our curated collection of articles, tips, and resources to enhance your well-being.',
        ),
        solidColor: Colors.green.shade200,
      ),

      // ③ Gradient + fully-custom button style
      CardItem(
        title: const Text('Cooking Made Easy'),
        body: const Text(
          'Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.',
        ),
        gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade600],
        isButton: true,
        buttonTitle: 'Get Started',
        buttonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.red),
          foregroundColor: WidgetStateProperty.all(Colors.yellow),
          textStyle: WidgetStateProperty.all(const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          )),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(65),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
        onTap: () => debugPrint('Big red button tapped!'),
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stacked Cards Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(title: const Text('Stacked Cards Example')),
        body: Center(
          child: SizedBox(
            height: 320,
            child: StackedCards(items: items),
          ),
        ),
      ),
    );
  }
}

/*──────────────── MODEL ─────────────────────────────*/
/// Immutable data that describes a single card in [StackedCards].
class CardItem {
  final Widget title;
  final Widget body;
  final String? buttonTitle;
  final ButtonStyle? buttonStyle;
  final GestureTapCallback? onTap;

  /// Provide **either** a gradient **or** a solid colour.
  final List<Color>? gradientColors;
  final Color? solidColor;
  final bool? isButton;
  final BorderRadius? borderRadius;

  CardItem({
    required this.title,
    required this.body,
    this.buttonTitle,
    this.buttonStyle,
    this.gradientColors,
    this.solidColor,
    this.isButton,
    this.borderRadius,
    this.onTap,
  });
}

/*──────────────── WIDGET ─────────────────────────────*/

/// A vertically-stacked card deck where one card can be expanded at a time.
///
/// Build a list of [CardItem]s and pass them into [StackedCards.items].

class StackedCards extends StatefulWidget {
  final List<CardItem> items;

  // layout knobs
  final double collapsedHeight;
  final double expandedHeight;
  final double overlap;
  final double cardBorderRadius;

  const StackedCards({
    super.key,
    required this.items,
    this.collapsedHeight = 100,
    this.expandedHeight = 240,
    this.overlap = 70,
    this.cardBorderRadius = 16,
  }) : assert(expandedHeight > collapsedHeight,
            'expandedHeight must be > collapsedHeight');

  @override
  State<StackedCards> createState() => _StackedCardsState();
}

class _StackedCardsState extends State<StackedCards> {
  double get _collapsed => widget.collapsedHeight;
  double get _expanded => widget.expandedHeight;
  double get _gap => widget.overlap;

  late List<CardItem> _items;
  late CardItem _selected;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
    _selected = _items.last;
  }

  @override
  Widget build(BuildContext context) {
    final totalH = _expanded + (_items.length - 1) * _gap;

    return SizedBox(
      height: totalH,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: _items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final top = idx * _gap;
          final cardH = item == _selected ? _expanded : _collapsed;

          /*──────── background ────────*/
          final fallback =
              Colors.primaries[idx % Colors.primaries.length].shade200;

          final bg = BoxDecoration(
            gradient: item.gradientColors != null
                ? LinearGradient(
                    colors: item.gradientColors!,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: item.gradientColors == null
                ? (item.solidColor ?? fallback)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          );

          return AnimatedPositioned(
            key: ValueKey(item.title),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: top,
            left: 20,
            right: 20,
            height: cardH,
            child: GestureDetector(
              onTap: () => _bringToFront(item),
              child: ClipRRect(
                borderRadius: item.borderRadius ??
                    BorderRadius.circular(widget.cardBorderRadius),
                child: Container(
                  decoration: bg,
                  child: item == _selected
                      ? _buildExpandedContent(item)
                      : _buildCollapsedHeader(item),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /*───────── helpers ─────────*/

  Widget _buildCollapsedHeader(CardItem item) => Padding(
        padding: const EdgeInsets.all(18),
        // padding: const EdgeInsets.only(left: 18, right: 30, top: 20, bottom: 10),
        child: DefaultTextStyle.merge(
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          child: item.title,
        ),
      );

  Widget _buildExpandedContent(CardItem item) => Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                DefaultTextStyle.merge(
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  child: item.title,
                ),
                const SizedBox(height: 12),
                DefaultTextStyle.merge(
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                  child: item.body,
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          if (item.isButton == true)
            Positioned(
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                style: item.buttonStyle ??
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                onPressed: item.onTap,
                child: Text(item.buttonTitle ?? 'Learn More'),
              ),
            ),
        ],
      );

  void _bringToFront(CardItem item) {
    setState(() {
      _items.remove(item);
      _items.add(item);
      _selected = item;
    });
  }
}
