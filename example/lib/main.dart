import 'package:flutter/material.dart';
import 'package:stacked_cards/stacked_cards.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    final items = [
      CardItem(
        title: const Text('Travel Tips'),
        body: const Text(
            'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.'),
        //solidColor: Colors.red
        // ← use a gradient
        // gradientColors: [Colors.blue.shade100, Colors.blue.shade400],
      ),
      CardItem(
        title: const Text('Health & Wellness'),
        body: const Text(
            'Explore our curated collection of health and wellness articles, tips, and resources to enhance your well-being.'),
        // ← use a solid colour instead
        // solidColor: Colors.green.shade200,
      ),
      CardItem(
        title: const Text('Cooking Made Easy'),

        isButton: true,
        buttonTitle: 'Get Started',
        buttonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(Colors.pink),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(65.0),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          textStyle: WidgetStateProperty.all(const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
        ),
        body: const Text(
            'Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.'),
        //gradientColors: [Colors.orange.shade200, Colors.deepOrange.shade600],
      ),
      CardItem(
        title: const Text('Health & Wellness'),
        body: const Text(
            'Explore our curated collection of health and wellness articles, tips, and resources to enhance your well-being.'),
        // ← use a solid colour instead
        // solidColor: Colors.green.shade200,
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
            height: 400,
            child: StackedCards(items: items),
          ),
        ),
      ),
    );
  }
}
