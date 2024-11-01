import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int caffeineAmount = 0;
  int selectedAmount = 0;
  String selectedBeverage = "";

  Color textColor = Colors.black;

  List<String> consumedBeverages = [];
  String consumedBeveragesString = "";

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void increaseCaffeineAmount(int amount) {
    setState(() {
      caffeineAmount += amount;
      saveCaffeineAmount(caffeineAmount);
      if (caffeineAmount > 400) {
        textColor = Colors.red;
      }
      editConsumedBeveragesString();
    });
  }

  void editConsumedBeveragesString() {
    consumedBeveragesString = consumedBeverages?.join("\n") ?? "";
  }

  void loadData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() async {
      caffeineAmount = preferences.getInt("caffeineAmount") ?? 0;
      if (await isNewDay()) {
        // Update your variable here
        caffeineAmount = 0;
        preferences.setInt('lastUpdatedDay', DateTime.now().day);
      }
    });
  }

  Future<bool> isNewDay() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastUpdated = preferences.getInt('lastUpdatedDay');

    if (lastUpdated == null) {
      preferences.setInt('lastUpdatedDay', now.day);
      return true;
    }

    return now.day != lastUpdated;
  }

  void saveCaffeineAmount(int amount) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("caffeineAmount", amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Heute: $caffeineAmount mg",
          style: TextStyle(color: textColor),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(consumedBeveragesString),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            DropdownMenu(
              dropdownMenuEntries: const <DropdownMenuEntry>[
                DropdownMenuEntry(value: 65, label: "Espresso"),
                DropdownMenuEntry(value: 75, label: "Kaffee Tasse"),
                DropdownMenuEntry(value: 150, label: "Kaffee Becher"),
                DropdownMenuEntry(value: 160, label: "Monster"),
                DropdownMenuEntry(value: 80, label: "Red Bull"),
              ],
              hintText: "Getränk...",
              onSelected: (value) {
                selectedAmount = value;
                selectedBeverage = value.label;
              },
              width: 300,
              enableFilter: true,
              enableSearch: true,
            ),
            TextButton(
              onPressed: () {
                increaseCaffeineAmount(selectedAmount);
                consumedBeverages.add(selectedBeverage);
              },
              child: const Icon(Icons.add),
            ),
          ]),
          const SizedBox(
            height: 25,
          )
        ],
      )),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.deepPurple,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.book_rounded)),
            label: 'Aufzeichnungen',
          ),
        ],
      ),
    );
  }
}
