import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import the Firebase Auth service

class UserAuthPage extends StatefulWidget {
  final String role;
  final bool isRoot; // When true, disables sign-up (only login allowed)

  const UserAuthPage({Key? key, required this.role, this.isRoot = false})
      : super(key: key);

  @override
  _UserAuthPageState createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  // By default, show login mode. If it's Root, we force login.
  bool isLogin = true;

  // Controllers for the email and password fields.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isRoot) {
      isLogin = true;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Calls the appropriate method from AuthService based on the mode.
  void _authenticate() {
    if (isLogin) {
      AuthService().signin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );
    } else {
      AuthService().signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set transparent background to display the bg image.
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
          // Semi-transparent dark overlay.
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main content area.
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
                    // Display a welcome message with the given role.
                    Text(
                      'Welcome, ${widget.role}',
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    // If not Root, allow toggling between Login and Sign Up.
                    if (!widget.isRoot) ...[
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
                    ],
                    // Email input field.
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
                    // Password input field.
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
                    // Button to trigger sign in or sign up.
                    ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(
                        widget.isRoot
                            ? 'Login as ${widget.role}'
                            : (isLogin
                            ? 'Login as ${widget.role}'
                            : 'Sign Up as ${widget.role}'),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
