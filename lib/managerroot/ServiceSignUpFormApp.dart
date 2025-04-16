import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const ServiceSignUpFormApp());
}

class ServiceSignUpFormApp extends StatelessWidget {
  const ServiceSignUpFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Sign Up Form',
      home: ServiceSignUpForm(),
    );
  }
}

class ServiceSignUpForm extends StatefulWidget {
  const ServiceSignUpForm({super.key});

  @override
  State<ServiceSignUpForm> createState() => _ServiceSignUpFormState();
}

class _ServiceSignUpFormState extends State<ServiceSignUpForm> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String _selectedCategory = "Catering";

  final List<String> _categories = [
    "Catering",
    "Decor",
    "Flowerist",
    "Lights and Sound"
  ];

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
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
          .child('service_uploads')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      _uploadedImageUrls.add(imageUrl);
    }
  }

  Future<void> _storeServiceData() async {
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }

    await FirebaseFirestore.instance.collection('servicedata').add({
      'name': _nameController.text.trim(),
      'category': _selectedCategory,
      'contact': _contactController.text.trim(),
      'street': _streetController.text.trim(),
      'locality': _localityController.text.trim(),
      'city': _cityController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'imageUrls': _uploadedImageUrls,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Service data submitted successfully!")),
    );

    _nameController.clear();
    _contactController.clear();
    _streetController.clear();
    _localityController.clear();
    _cityController.clear();
    _pincodeController.clear();
    setState(() {
      _selectedCategory = "Catering";
      _selectedImages.clear();
      _uploadedImageUrls.clear();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _streetController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Sign Up Form")),
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
                  "Upload Service Images",
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
                  decoration: const InputDecoration(labelText: "Company/Service Provider Name"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: "Contact Number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose the category from the following:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),

                ..._categories.map((category) => RadioListTile(
                  title: Text(category),
                  value: category,
                  groupValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                )),
                const SizedBox(height: 16),

                TextField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: "Street"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _localityController,
                  decoration: const InputDecoration(labelText: "Locality"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: "Town / City"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _pincodeController,
                  decoration: const InputDecoration(labelText: "Pincode"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _storeServiceData,
                  child: const Text("Submit Service Data"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
