import 'package:flutter/material.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// {@template home_screen}
/// ExampleScreen widget.
/// {@endtemplate}
class ExampleScreen extends StatefulWidget {
  /// {@macro home_screen}
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  bool isNavBarEnabled = true;

  @override
  Widget build(BuildContext context) {
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
              value: isNavBarEnabled,
              onChanged: (res) => setState(
                () => isNavBarEnabled = res,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Show Error Snackbar'),
              onPressed: () {
                InsightSnackBar.showError(context);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Show Successful Snackbar'),
              onPressed: () {
                InsightSnackBar.showSuccessful(context);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: isNavBarEnabled
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
