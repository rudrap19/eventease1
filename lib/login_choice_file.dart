import 'package:flutter/material.dart';
import 'user_auth_page.dart';
import 'manager_auth_page.dart';

/// This page displays separate login options for Users, Event Managers, and Root.
/// - Users and Root use Firebase Authentication.
/// - Event Managers use a custom flow that stores their details in Firestore.
class LoginChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background image.
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay.
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content.
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo image.
                  Image.asset(
                    'assets/logo.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 50),
                  // User authentication button (Firebase Auth).
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAuthPage(role: "User"),
                        ),
                      );
                    },
                    child: Text('User Login/Sign Up'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 60),
                      backgroundColor: Color(0xFF75BEE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Event Manager authentication button (Firestore-based).
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagerAuthPage(role: "Event Manager"),
                        ),
                      );
                    },
                    child: Text('Event Manager Login/Sign Up'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 60),
                      backgroundColor: Color(0xFF75BEE8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  // Root login using Firebase Authentication.
                  Text(
                    "Root Login",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // For Root, we disable sign-up.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAuthPage(role: "Root", isRoot: true),
                        ),
                      );
                    },
                    child: Text('Login as Root'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 60),
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
}
