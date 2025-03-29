import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_choice_file.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

/// The root widget for the Event Ease app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if a user is already signed in.
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Event Ease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: currentUser != null ? HomePage() : LoginChoicePage(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}
