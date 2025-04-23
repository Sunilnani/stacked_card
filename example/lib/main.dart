import 'package:flutter/material.dart';
import 'package:stacked_cards/stacked_cards.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      CardItem(
        title: 'Travel Tips',
        body:
        'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.',
        icon: Icons.flight_takeoff,
        //solidColor: Colors.red
        // ← use a gradient
        gradientColors: [Colors.blue.shade100, Colors.blue.shade400],
      ),
      CardItem(
        title: 'Healthy Recipes',
        body:
        'Wholesome and delicious recipes tailored for every taste. From smoothies to full-course meals!',
        icon: Icons.restaurant_menu,
        // ← use a solid colour instead
        solidColor: Colors.green.shade200,
      ),
      CardItem(
        title: 'Workout Plans',
        isButton: true,
        buttonTitle: 'Get Started',
        body:
        'Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.',
        icon: Icons.fitness_center,
        gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade600],
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

/*――――――――――――――  MODEL  ――――――――――――*/

class CardItem {
  final String title;
  final String body;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final String? buttonTitle;
  final TextStyle? buttonTextStyle;
  final ButtonStyle? buttonStyle;
  final IconData? icon;

  /// Provide **either** a gradient **or** a solid colour.
  final List<Color>? gradientColors;
  final Color? solidColor;
  final bool? isButton;

  CardItem({
    required this.title,
    required this.body,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.buttonTitle,
    this.buttonTextStyle,
    this.buttonStyle,
    this.icon,
    this.gradientColors,
    this.solidColor,
    this.isButton,
  }) : assert(
  (gradientColors != null && gradientColors.length >= 2) ||
      (solidColor != null),
  'You must supply either at least two gradient colours or one solid colour',
  );
}

/*――――――――――――――  WIDGET  ――――――――――――*/

class StackedCards extends StatefulWidget {
  final List<CardItem> items;
  const StackedCards({super.key, required this.items});

  @override
  State<StackedCards> createState() => _StackedCardsState();
}

class _StackedCardsState extends State<StackedCards> {
  static const double _collapsedHeight = 100;
  static const double _expandedHeight  = 240;
  static const double _overlap         = 70;

  late List<CardItem> _items;
  late CardItem _selected;

  @override
  void initState() {
    super.initState();
    _items    = List.of(widget.items);
    _selected = _items.last;
  }

  @override
  Widget build(BuildContext context) {
    final totalH = _expandedHeight + (_items.length - 1) * _overlap;

    return SizedBox(
      height: totalH,
      width : double.infinity,
      child : Stack(
        clipBehavior: Clip.none,
        children: _items.asMap().entries.map((entry) {
          final idx       = entry.key;
          final item      = entry.value;
          final selected  = item == _selected;
          final top       = idx * _overlap;
          final cardH     = selected ? _expandedHeight : _collapsedHeight;

          // Decide whether to paint a gradient or a solid colour
          final BoxDecoration bg = (item.gradientColors != null)
              ? BoxDecoration(
            gradient: LinearGradient(
              colors: item.gradientColors!,
              begin : Alignment.topLeft,
              end   : Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          )
              : BoxDecoration(
            color: item.solidColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          );

          return AnimatedPositioned(
            key     : ValueKey(item.title),
            duration: const Duration(milliseconds: 300),
            curve   : Curves.easeInOut,
            top     : top,
            left    : 20,
            right   : 20,
            height  : cardH,
            child   : GestureDetector(
              onTap: () => _bringToFront(item),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: bg,
                  child: ListView(
                    physics: selected
                        ? const AlwaysScrollableScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      // header
                      Row(
                        children: [
                          Icon(item.icon, color: Colors.black87, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: item.titleTextStyle ?? TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // details only when expanded
                      if (selected) ...[
                        const SizedBox(height: 12),
                        Text(
                          item.body,
                          style: item.bodyTextStyle ?? TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        item.isButton == true ?
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style:item.buttonStyle ?? ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child:  Text(item.buttonTitle ?? 'Learn More',style:item.buttonTextStyle ?? TextStyle(color: Colors.black87,fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        ) : const SizedBox.shrink(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
