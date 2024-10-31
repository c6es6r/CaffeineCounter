import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int caffeineAmount = 0;

  void increaseCaffeineAmount(int amount) {
    setState(() {
      caffeineAmount += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Today's Caffeine Intake: $caffeineAmount mg"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                increaseCaffeineAmount(100); // Adjust the amount as needed
              },
              child: const Text('Add 100mg Caffeine'),
            ),
          ],
        ),
      ),
    );
  }
}