import 'package:flutter/material.dart';
import '../user_auth_page.dart';
import '../manager_auth_page.dart';
import 'venuesignupform.dart';

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
    // Navigate to the appropriate signup page based on the selected option.
    if (_selectedOption == "Manager") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManagerAuthPage(role: "Event Manager"),
        ),
      );
    } else if (_selectedOption == "Venue") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAuthPage(role: "Venue"),
        ),
      );
    } else if (_selectedOption == "Services") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAuthPage(role: "Services"),
        ),
      );
    } else if (_selectedOption == "Products") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserAuthPage(role: "Products"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Signup Option"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RadioListTile<String>(
              title: const Text("Venue"),
              value: "Venue",
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Manager"),
              value: "Manager",
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Services"),
              value: "Services",
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text("Products"),
              value: "Products",
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
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
    );
  }
}
