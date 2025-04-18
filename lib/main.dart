import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'login_choice_file.dart';
import 'home_page.dart';
import 'managerroot/ManagerPageroot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userRole = prefs.getString('userRole') ?? '';

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userRole: userRole,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userRole;

  const MyApp({Key? key, required this.isLoggedIn, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget initialPage;

    if (isLoggedIn) {
      if (userRole == 'manager') {
        initialPage = const ManagerPageroot();
      } else {
        initialPage = const HomePage(); // Default to user
      }
    } else {
      initialPage = const LoginChoicePage();
    }

    return MaterialApp(
      title: 'Event Ease',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialPage,
      routes: {
        '/home': (context) => const HomePage(),
        '/managerHome': (context) => const ManagerPageroot(),
      },
    );
  }
}
