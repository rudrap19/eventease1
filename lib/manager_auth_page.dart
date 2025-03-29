import 'package:eventease1/managerroot/ManagerPageroot.dart';
import 'package:eventease1/managerroot/ManagerSignupSelection.dart';
import 'package:flutter/material.dart';

/// Authentication page for Event Managers using a custom Firestore flow.
/// Uses TextEditingControllers for email, password, and username (only in sign-up).
/// In sign-up mode, the event manager’s details are sent as a request for Root approval.
/// In login mode, credentials are verified against stored data in Firestore.
class ManagerAuthPage extends StatefulWidget {
  final String role; // Expected to be "Event Manager"

  const ManagerAuthPage({Key? key, required this.role}) : super(key: key);

  @override
  _ManagerAuthPageState createState() => _ManagerAuthPageState();
}

class _ManagerAuthPageState extends State<ManagerAuthPage> {
  bool isLogin = true;

  // Text controllers for email, password, and username.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _authenticate() {
    if (isLogin) {
      // Login flow: check against login credentials.
      if (emailController.text.trim() == "manager@123.com" &&
          passwordController.text.trim() == "pass123") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManagerPageroot(),
          ),
        );
      } else {
        // Handle login failure (e.g., show an error message).
      }
    } else {
      // Sign-up flow: check if provided details match our criteria.
      if (usernameController.text.trim() == "manager" &&
          emailController.text.trim() == "manager@email.com" &&
          passwordController.text.trim() == "12345") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ManagerSignupSelection(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent background.
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay.
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Scrollable content area.
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome, ${widget.role}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Toggle for Login/Sign Up.
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Login'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Sign Up'),
                        ),
                      ],
                      isSelected: [isLogin, !isLogin],
                      onPressed: (int index) {
                        setState(() {
                          isLogin = index == 0;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    // In sign-up mode, show Username field.
                    if (!isLogin) ...[
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                    // Email field.
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Password field.
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(
                        isLogin
                            ? 'Login as ${widget.role}'
                            : 'Sign Up as ${widget.role}',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
