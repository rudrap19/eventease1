import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../managerroot/ManagerPageroot.dart'; // Adjust the path if needed

void main() {
  runApp(const ManagerSignUpFormApp());
}

class ManagerSignUpFormApp extends StatelessWidget {
  const ManagerSignUpFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager Sign Up Form',
      home: ManagerSignUpForm(),
    );
  }
}

class ManagerSignUpForm extends StatefulWidget {
  const ManagerSignUpForm({super.key});

  @override
  State<ManagerSignUpForm> createState() => _ManagerSignUpFormState();
}

class _ManagerSignUpFormState extends State<ManagerSignUpForm> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _typesController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadImages() async {
    _uploadedImageUrls.clear();
    for (var image in _selectedImages) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('manager_uploads')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      _uploadedImageUrls.add(imageUrl);
    }
  }

  Future<void> _storeManagerData() async {
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }

    try {
      await FirebaseFirestore.instance.collection('managerdata').add({
        'name': _nameController.text.trim(),
        'experience': _experienceController.text.trim(),
        'typesOfEvent': _typesController.text.trim(),
        'averagePricing': _pricingController.text.trim(),
        'location': _locationController.text.trim(),
        'servicesProvided': _servicesController.text.trim(),
        'imageUrls': _uploadedImageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear form
      _nameController.clear();
      _experienceController.clear();
      _typesController.clear();
      _pricingController.clear();
      _locationController.clear();
      _servicesController.clear();
      setState(() {
        _selectedImages.clear();
        _uploadedImageUrls.clear();
      });

      // ✅ Redirect to manager root
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ManagerPageroot()),
      );
    } catch (e) {
      print("Error storing manager data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _experienceController.dispose();
    _typesController.dispose();
    _pricingController.dispose();
    _locationController.dispose();
    _servicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manager Sign Up Form")),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Upload Manager Images",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _selectedImages.isNotEmpty
                    ? SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          _selectedImages[index],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
                    : const Placeholder(fallbackHeight: 200),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text("Pick Images"),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _experienceController,
                  decoration: const InputDecoration(labelText: "Experience"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _typesController,
                  decoration: const InputDecoration(labelText: "Types of Events"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _pricingController,
                  decoration: const InputDecoration(labelText: "Average Pricing (₹)"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _servicesController,
                  decoration: const InputDecoration(labelText: "Services Provided"),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _storeManagerData,
                  child: const Text("Submit Manager Data"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
