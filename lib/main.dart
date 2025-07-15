import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'services/firestore_service.dart';
import 'theme/app_theme.dart';
import 'utils/nepali_strings.dart';

String? _errorMessage;

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      // Initialize Firebase only if not already initialized
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyD7FuD02Lk4-PPQABRSXcoZ-rUSb8yLzE8',
          appId: '1:23112280246:android:384b4c1d96d5b523081e17',
          messagingSenderId: '23112280246',
          projectId: 'digital-khata-63c4d',
          storageBucket: 'digital-khata-63c4d.firebasestorage.app',
        ),
      );
    }

    // Enable offline persistence only if not already enabled
    try {
      await FirebaseFirestore.instance.enablePersistence();
    } catch (e) {
      // Ignore error if persistence is already enabled
      print('Persistence might already be enabled: $e');
    }

    runApp(const MyApp());
  } catch (e) {
    _errorMessage = e.toString();
    print('Error initializing app: $e');
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NepaliStrings.appName,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error Initializing App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'Unknown error occurred',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FirestoreService>(
      create: (_) => FirestoreService(),
      child: MaterialApp(
        title: NepaliStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
      ),
    );
  }
}
