import 'package:flutter/material.dart';
import 'package:stacked_cards/stacked_cards.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      CardItem(
        title: const Text('Travel Tips'),
        body: const Text(
            'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.'),
        icon: Icons.flight_takeoff,
        gradientColors: [Colors.blue.shade100, Colors.blue.shade400],
      ),
      CardItem(
        title: const Text('Health & Wellness'),
        body: const Text(
            'Explore our curated collection of health and wellness articles, tips, and resources to enhance your well‑being.'),
        icon: Icons.restaurant_menu,
        solidColor: Colors.green.shade200,
      ),
      CardItem(
        title: const Text('Cooking Made Easy'),
        body: const Text(
            'Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.'),
        icon: Icons.fitness_center,
        gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade600],
        isButton: true,
        buttonTitle: 'Get Started',
      ),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stacked Cards Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('Stacked Cards Example')),
        body: Center(
          child: SizedBox(
            height: 300,
            child: StackedCards(items: items),
          ),
        ),
      ),
    );
  }
}

/*──────────────── MODEL ─────────────────────────────*/

class CardItem {
  final Widget title;
  final Widget body;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final String? buttonTitle;
  final TextStyle? buttonTextStyle;
  final ButtonStyle? buttonStyle;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final GestureTapCallback? onTap;

  /// Provide **either** a gradient **or** a solid colour.
  final List<Color>? gradientColors;
  final Color? solidColor;
  final bool? isButton;
  final BorderRadius? borderRadius;

  CardItem({
    required this.title,
    required this.body,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.buttonTitle,
    this.buttonTextStyle,
    this.buttonStyle,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.gradientColors,
    this.solidColor,
    this.isButton,
    this.borderRadius,
    this.onTap,
  }) : assert(
  (gradientColors != null && gradientColors.length >= 2) ||
      (solidColor != null),
  'You must supply either at least two gradient colours or one solid colour',
  );
}

/*──────────────── WIDGET ─────────────────────────────*/

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
          final selected = item == _selected;
          final top = idx * _gap;
          final cardH = selected ? _expanded : _collapsed;

          final bg = BoxDecoration(
            gradient: item.gradientColors != null
                ? LinearGradient(
              colors: item.gradientColors!,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: item.gradientColors == null ? item.solidColor : null,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
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
                borderRadius:
                item.borderRadius ?? BorderRadius.circular(widget.cardBorderRadius),
                child: Container(
                  decoration: bg,
                  child: selected
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

  Widget _buildCollapsedHeader(CardItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,bottom: 30),
      child: Row(
        children: [
          Icon(item.icon,
              color: item.iconColor ?? Colors.black87,
              size: item.iconSize ?? 20),
          const SizedBox(width: 12),
          Expanded(
            child: DefaultTextStyle.merge(
              style: item.titleTextStyle ??
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              child: item.title,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpandedContent(CardItem item) {
    return Stack(
      children: [
        // ❶ Scrollable content fills the card
        Positioned.fill(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Icon(item.icon,
                      color: item.iconColor ?? Colors.black87,
                      size: item.iconSize ?? 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: item.titleTextStyle ??
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      child: item.title,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DefaultTextStyle.merge(
                style: item.bodyTextStyle ??
                    const TextStyle(fontSize: 16, color: Colors.black54),
                child: item.body,
              ),
              const SizedBox(height: 60), // leave breathing room above the button
            ],
          ),
        ),

        // ❷ Button pinned bottom‑right (if requested)
        if (item.isButton == true)
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              style: item.buttonStyle ??
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
              onPressed: item.onTap,
              child: Text(
                item.buttonTitle ?? 'Learn More',
                style: item.buttonTextStyle ??
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
      ],
    );
  }

  void _bringToFront(CardItem item) {
    setState(() {
      _items.remove(item);
      _items.add(item);
      _selected = item;
    });
  }
}
