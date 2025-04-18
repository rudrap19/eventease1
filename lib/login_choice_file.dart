import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_auth_page.dart';
import 'manager_auth_page.dart';
import 'managerroot/ManagerPageroot.dart';

class LoginChoicePage extends StatefulWidget {
  const LoginChoicePage({Key? key}) : super(key: key);

  @override
  _LoginChoicePageState createState() => _LoginChoicePageState();
}

class _LoginChoicePageState extends State<LoginChoicePage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole');

    if (isLoggedIn && userRole == 'manager') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ManagerPageroot()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(color: Colors.black.withOpacity(0.5)),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  const SizedBox(height: 50),

                  // User Auth
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserAuthPage(role: "User"),
                        ),
                      );
                    },
                    child: const Text('User Login/Sign Up'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 20),

                  // Manager Auth (merged Sign In + Sign Up)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManagerAuthPage(role: "Event Manager"),
                        ),
                      );
                    },
                    child: const Text('Event Manager Login/Sign Up'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    "Root Login",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  // Root Auth
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserAuthPage(role: "Root", isRoot: true),
                        ),
                      );
                    },
                    child: const Text('Login as Root'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 60),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      minimumSize: const Size(250, 60),
      backgroundColor: const Color(0xFF75BEE8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
