import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_choice_file.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

/// The root widget for the Event Ease app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Ease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginChoicePage(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

