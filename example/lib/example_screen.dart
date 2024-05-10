import 'package:flutter/material.dart';
import 'package:insight_snackbar/insight_snackbar.dart';

/// {@template home_screen}
/// ExampleScreen widget.
/// {@endtemplate}
class ExampleScreen extends StatelessWidget {
  /// {@macro home_screen}
  const ExampleScreen({super.key});

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
            ElevatedButton(
              child: const Text('Show Error Snackbar'),
              onPressed: () {
                InsightSnackBar.showError(
                  context,
                  title: 'Error',
                  message: 'Error Message',
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Show Successful Snackbar'),
              onPressed: () {
                InsightSnackBar.showSuccessful(
                  context,
                  title: 'Successful',
                  message: 'Successful Message',
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
