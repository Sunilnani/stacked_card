import 'package:flutter/material.dart';
import 'package:stacked_cards/stacked_cards.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      CardItem(
        title: 'Travel Tips',
        body:
        'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.',
        icon: Icons.flight_takeoff,
        gradientColors: [
          Colors.blue.shade200,
          Colors.blue.shade400,
        ],
      ),
      CardItem(
        title: 'Healthy Recipes',
        body:
        'Wholesome and delicious recipes tailored for every taste. From smoothies to full-course meals!',
        icon: Icons.restaurant_menu,
        gradientColors: [
          Colors.green.shade200,
          Colors.green.shade400,
        ],
      ),
      CardItem(
        title: 'Workout Plans',
        body:
        'Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.',
        icon: Icons.fitness_center,
        gradientColors: [
          Colors.orange.shade200,
          Colors.deepOrange.shade400,
        ],
      ),
    ];

    return MaterialApp(
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



/// A single card item with its own gradient colors.
class CardItem {
  final String title;
  final String body;
  final IconData icon;
  final List<Color> gradientColors;

  CardItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.gradientColors,
  });
}

/// A stack of tappable cards that animate to the front and expand,
/// preserving each card's unique gradient colors.
class StackedCards extends StatefulWidget {
  /// The list of cards to display.
  final List<CardItem> items;
  const StackedCards({Key? key, required this.items}) : super(key: key);

  @override
  _StackedCardsState createState() => _StackedCardsState();
}

class _StackedCardsState extends State<StackedCards> {
  static const double _collapsedHeight = 70.0;
  static const double _expandedHeight = 240.0;
  static const double _overlap = 50.0;

  late List<CardItem> _items;
  late CardItem _selected;

  @override
  void initState() {
    super.initState();
    // Clone the list so we can reorder
    _items = List.from(widget.items);
    _selected = _items.last;
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = _expandedHeight + (_items.length - 1) * _overlap;

    return Center(
      child: SizedBox(
        height: totalHeight,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = item == _selected;
            final topOffset = index * _overlap;
            final cardHeight = isSelected ? _expandedHeight : _collapsedHeight;
            // Use each item's own gradient
            final colors = item.gradientColors;

            return AnimatedPositioned(
              key: ValueKey(item.title),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: topOffset,
              left: 20,
              right: 20,
              height: cardHeight,
              child: GestureDetector(
                onTap: () => _onTap(item),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListView(
                      physics: isSelected
                          ? const AlwaysScrollableScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        Row(
                          children: [
                            Icon(item.icon, color: Colors.black87, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 12),
                          Text(
                            item.body,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: colors.last,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Learn More'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onTap(CardItem item) {
    setState(() {
      _items.remove(item);
      _items.add(item);
      _selected = item;
    });
  }
}