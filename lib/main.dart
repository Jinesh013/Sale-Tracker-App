import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saletrackerapp/src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Display error message if Firebase initialization fails
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Firebase Initialization Failed: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            ),
          );
        }

        // Show a loading spinner while waiting for Firebase initialization
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Once initialized, show the main SalesTrackerApp
        return SalesTrackerApp();
      },
    );
  }
}
