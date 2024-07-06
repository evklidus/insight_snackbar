import 'package:insight_snackbar/insight_snackbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool isBottomNavEnabled = true;

  @override
  Widget build(BuildContext context) {
    final snackBarPadding = isBottomNavEnabled ? 80 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insight Snackbar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            const SizedBox(height: 20),
            Switch.adaptive(
              value: isBottomNavEnabled,
              onChanged: (res) => setState(
                () => isBottomNavEnabled = res,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Show Error Snackbar'),
              onPressed: () {
                InsightSnackBar.showError(
                  context,
                  bottomPadding: snackBarPadding,
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Show Successful Snackbar'),
              onPressed: () {
                InsightSnackBar.showSuccessful(
                  context,
                  bottomPadding: snackBarPadding,
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: isBottomNavEnabled
          ? NavigationBar(
              onDestinationSelected: (tappedIndex) {},
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(Icons.home_filled),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                )
              ],
            )
          : null,
    );
  }
}
