import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({Key? key}) : super(key: key);

  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  File? _selectedImage;
  String _uploadedImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  // Controllers for compare data fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // Pick an image from the gallery.
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage (under 'compare_uploads') and retrieve its URL.
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('compare_uploads')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = imageUrl;
      });
      print("IN Method in firestore");
      print("Uploaded Image URL: $_uploadedImageUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  // Store compare data (name, age, gender, and image URL) in Firestore.
  Future<void> _storeCompareData() async {
    try {
      await FirebaseFirestore.instance.collection('compare_data').add({
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'gender': _genderController.text.trim(),
        'imageUrl': _uploadedImageUrl,
      });
      print("Compare data stored successfully.");
    } catch (e) {
      print("Error storing compare data: $e");
    }
  }

  // Retrieve and print all compare data from Firestore.
  Future<void> _retrieveCompareData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('compare_data').get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        print("Compare Data: Name: ${data['name']}, Age: ${data['age']}, Gender: ${data['gender']}, Image URL: ${data['imageUrl']}");
      }
    } catch (e) {
      print("Error retrieving compare data: $e");
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
        title: const Text("Compare"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Section for image upload.
            Text(
              "Upload Compare Image",
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
            // Section for storing and retrieving compare data.
            Text(
              "Store Compare Data",
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
              onPressed: _storeCompareData,
              child: const Text("Store Data"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _retrieveCompareData,
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
