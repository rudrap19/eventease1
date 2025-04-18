import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(ManagerSignUpFormApp());
}

class ManagerSignUpFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager Sign Up Form',
      home: ManagerSignUpForm(),
    );
  }
}

class ManagerSignUpForm extends StatefulWidget {
  const ManagerSignUpForm({Key? key}) : super(key: key);

  @override
  _ManagerSignUpFormState createState() => _ManagerSignUpFormState();
}

class _ManagerSignUpFormState extends State<ManagerSignUpForm> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  // Controllers for event manager details.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _typesController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  // Pick multiple images from the gallery.
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages =
            pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // Upload each image to Firebase Storage and collect its download URL.
  Future<void> _uploadImages() async {
    _uploadedImageUrls = [];
    for (var image in _selectedImages) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('manager_uploads')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(image);
        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();
        _uploadedImageUrls.add(imageUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    setState(() {});
  }

  // Store manager data (including the list of image URLs) in Firestore under "managerdata".
  Future<void> _storeManagerData() async {
    // Upload images if any are selected.
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }
    try {
      await FirebaseFirestore.instance.collection('manager_data1').add({
        'name': _nameController.text.trim(),
        'experience': _experienceController.text.trim(),
        'typesOfEvent': _typesController.text.trim(),
        'averagePricing': _pricingController.text.trim(),
        'location': _locationController.text.trim(),
        'servicesProvided': _servicesController.text.trim(),
        'imageUrls': _uploadedImageUrls,
      });
      print("Manager data stored successfully.");
      // Clear the form fields after a successful upload.
      _nameController.clear();
      _experienceController.clear();
      _typesController.clear();
      _pricingController.clear();
      _locationController.clear();
      _servicesController.clear();
      setState(() {
        _selectedImages = [];
        _uploadedImageUrls = [];
      });
    } catch (e) {
      print("Error storing manager data: $e");
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
      // Use a Stack to add a background image.
      appBar: AppBar(
        title: const Text("Event Manager Sign Up Form"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
          // Main content area.
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Section for image selection.
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
                // Text field for Name.
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 8),
                // Text field for Experience.
                TextField(
                  controller: _experienceController,
                  decoration: const InputDecoration(labelText: "Experience"),
                ),
                const SizedBox(height: 8),
                // Text field for Types of Event to Manage.
                TextField(
                  controller: _typesController,
                  decoration: const InputDecoration(
                      labelText: "Types of Event to Manage"),
                ),
                const SizedBox(height: 8),
                // Text field for Average Pricing Expected.
                TextField(
                  controller: _pricingController,
                  decoration: const InputDecoration(
                      labelText: "Average Pricing Expected"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                // Text field for Location.
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                const SizedBox(height: 8),
                // Text field for Services Provided.
                TextField(
                  controller: _servicesController,
                  decoration:
                  const InputDecoration(labelText: "Services Provided"),
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
