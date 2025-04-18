import 'package:flutter/material.dart';
import '../user_auth_page.dart';
import '../manager_auth_page.dart';
import 'ManagerSignUpFormApp.dart';
import 'ProductSignupFormApp.dart';
import 'ServiceSignUpFormApp.dart';
import 'VenueSignUpFormApp.dart';


class ManagerSignupSelection extends StatefulWidget {
  const ManagerSignupSelection({Key? key}) : super(key: key);

  @override
  _ManagerSignupSelectionState createState() => _ManagerSignupSelectionState();
}

class _ManagerSignupSelectionState extends State<ManagerSignupSelection> {
  String? _selectedOption;

  void _managerSignupSelection() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an option")),
      );
      return;
    }

    if (_selectedOption == "Manager") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerSignUpFormApp(),
        ),
      );
    } else if (_selectedOption == "Venue") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VenueSignUpFormApp(),
        ),
      );
    } else if (_selectedOption == "Services") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceSignUpFormApp(),
        ),
      );
    } else if (_selectedOption == "Products") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductSignUpFormApp()
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the AppBar background to transparent.
      appBar: AppBar(
        title: const Text("Select Signup Option"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Extend the body behind the AppBar.
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image container.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay the content on top of the background.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text("Venue"),
                    value: "Venue",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Manager"),
                    value: "Manager",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Services"),
                    value: "Services",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text("Products"),
                    value: "Products",
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() => _selectedOption = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _managerSignupSelection,
                    child: const Text("Confirm"),
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
