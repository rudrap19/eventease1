import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'managerroot/ManagerPageroot.dart';
import 'managerroot/ManagerSignupSelection.dart';

class ManagerAuthPage extends StatefulWidget {
  final String role;
  final bool isRoot;

  const ManagerAuthPage({Key? key, required this.role, this.isRoot = false}) : super(key: key);

  @override
  _ManagerAuthPageState createState() => _ManagerAuthPageState();
}

class _ManagerAuthPageState extends State<ManagerAuthPage> {
  bool isSignUpMode = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (isSignUpMode) {
      if (password != confirmPasswordController.text.trim()) {
        _showMessage("Passwords do not match");
        return;
      }

      try {
        await AuthService().signup(
          email: email,
          password: password,
          context: context,
        );

        await FirebaseFirestore.instance.collection('managerinfo').add({
          'name': nameController.text.trim(),
          'email': email,
          'password': password,
          'timestamp': FieldValue.serverTimestamp(),
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userRole', 'manager');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ManagerSignupSelection ()),
        );
      } catch (e) {
        _showMessage("Signup failed: $e");
      }
    } else {
      try {
        final query = await FirebaseFirestore.instance
            .collection('managerinfo')
            .where('email', isEqualTo: email)
            .where('password', isEqualTo: password)
            .get();

        if (query.docs.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userEmail', email);
          await prefs.setString('userRole', 'manager');

          _showMessage("Login successful!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ManagerPageroot()),
          );
        } else {
          _showMessage("Invalid email or password");
        }
      } catch (e) {
        _showMessage("Login failed: $e");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white70),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      backgroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSignUpMode ? 'Manager Sign Up' : 'Manager Sign In',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  if (isSignUpMode)
                    Column(
                      children: [
                        TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Name"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Email"),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Password"),
                  ),
                  if (isSignUpMode) ...[
                    const SizedBox(height: 20),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("Confirm Password"),
                    ),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(isSignUpMode ? 'Sign Up' : 'Sign In'),
                    style: _buttonStyle(),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignUpMode = !isSignUpMode;
                      });
                    },
                    child: Text(
                      isSignUpMode
                          ? 'Already have an account? Sign In'
                          : 'Don\'t have an account? Sign Up',
                      style: const TextStyle(color: Colors.white70),
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
