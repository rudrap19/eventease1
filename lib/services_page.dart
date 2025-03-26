import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  File? _selectedImage;
  String _uploadedImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  // Controllers for user data fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // Replace <YOUR_FIREBASE> with your project id.
  final String databaseURL = "https://eventease-38aca-default-rtdb.firebaseio.com/";

  // Pick an image from the gallery.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage and retrieve its URL.
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = imageUrl;
      });
      print("Uploaded Image URL: $_uploadedImageUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Store user data (name, age, gender) in Firebase Realtime Database.
  Future<void> _storeUserData() async {
    try {
      // Create a new entry under "users" with a unique key.
      DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseURL,
      ).ref('users').push();
      await ref.set({
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'gender': _genderController.text.trim(),
      });
      print("User data stored successfully in Realtime Database.");
    } catch (e) {
      print("Error storing user data: $e");
    }
  }

  // Retrieve and print all user data from Firebase Realtime Database.
  Future<void> _retrieveUserData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseURL,
      ).ref('users');
      final snapshot = await ref.get();
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        data.forEach((key, value) {
          print("User Data: Name: ${value['name']}, Age: ${value['age']}, Gender: ${value['gender']}");
        });
      } else {
        print("No user data found.");
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section for image upload.
            Text(
              "Image Upload",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 16),
            // Section for storing and retrieving user data.
            Text(
              "Store User Data",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: "Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: "Gender"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _storeUserData,
              child: const Text("Store Data"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _retrieveUserData,
              child: const Text("Retrieve Data"),
            ),
            const SizedBox(height: 16),
            if (_uploadedImageUrl.isNotEmpty)
              Text("Uploaded Image URL: $_uploadedImageUrl"),
          ],
        ),
      ),
    );
  }
}
