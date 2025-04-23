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
        title: Text('Travel Tips'),
        body:
       Text( 'Discover hidden gems around the world with our exclusive travel guides and insider recommendations.'),
        icon: Icons.flight_takeoff,
        //solidColor: Colors.red
        // ← use a gradient
        gradientColors: [Colors.blue.shade100, Colors.blue.shade400],
      ),
      CardItem(
        title: Text('Health & Wellness'),
        body:
        Text('Explore our curated collection of health and wellness articles, tips, and resources to enhance your well-being.'),
        icon: Icons.restaurant_menu,
        // ← use a solid colour instead
        solidColor: Colors.green.shade200,
      ),
      CardItem(
        title: Text('Cooking Made Easy'),

        isButton: true,
        buttonTitle: 'Get Started',
        buttonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(65.0),
            side: const BorderSide(color: Colors.black),
          ),),
        ),
        body:
        Text('Customized workouts for all fitness levels. Stay motivated with progress tracking and tips.'),
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
            height: 400,
            child: StackedCards(
                items: items
            ),
          ),
        ),
      ),
    );
  }
}


