import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(VenueSignUpFormApp());
}

class VenueSignUpFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venue Sign Up Form',
      home: VenueSignUpForm(),
    );
  }
}

class VenueSignUpForm extends StatefulWidget {
  const VenueSignUpForm({Key? key}) : super(key: key);

  @override
  _VenueSignUpFormState createState() => _VenueSignUpFormState();
}

class _VenueSignUpFormState extends State<VenueSignUpForm> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages =[];
  List<String> _uploadedImageUrls = [];

  // Controllers for venue details
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timingsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // Radio button selection for venue type with a default value.
  String _venueType = "Club";

  // Pick multiple images from the gallery.
  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
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
            .child('venue_uploads')
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

  // Store the venue data (including the list of image URLs) in the Firestore collection "venuedata".
  Future<void> _storeVenueData() async {
    // Upload images if any are selected.
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }

    try {
      await FirebaseFirestore.instance.collection('venuedata').add({
        'name': _nameController.text.trim(),
        'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
        'venueType': _venueType,
        'location': _locationController.text.trim(),
        'timings': _timingsController.text.trim(),
        'contact': _contactController.text.trim(),
        'imageUrls': _uploadedImageUrls,
      });
      print("Venue data stored successfully.");
      // Optionally, clear the form fields after a successful upload.
      _nameController.clear();
      _capacityController.clear();
      _locationController.clear();
      _timingsController.clear();
      _contactController.clear();
      setState(() {
        _selectedImages = [];
        _uploadedImageUrls = [];
        _venueType = "Club"; // Reset to default
      });
    } catch (e) {
      print("Error storing venue data: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    _timingsController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added background image using a Stack.
      appBar: AppBar(
        title: const Text("Venue Sign Up Form"),
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
          // Main  content area.
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Section for image selection.
                Text(
                  "Upload Venue Images",
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
                // Text field for Venue Name.
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Venue Name"),
                ),
                const SizedBox(height: 8),
                // Text field for Capacity.
                TextField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: "Capacity"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                // Label for Venue Type with updated text style.
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Venue Type:",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Radio buttons for Venue Type.
                Row(
                  children: [
                    Radio<String>(
                      value: "Club",
                      groupValue: _venueType,
                      onChanged: (value) {
                        setState(() {
                          _venueType = value!;
                        });
                      },
                    ),
                    const Text("Club"),
                    Radio<String>(
                      value: "Party Hall",
                      groupValue: _venueType,
                      onChanged: (value) {
                        setState(() {
                          _venueType = value!;
                        });
                      },
                    ),
                    const Text("Party Hall"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "Open Grounds",
                      groupValue: _venueType,
                      onChanged: (value) {
                        setState(() {
                          _venueType = value!;
                        });
                      },
                    ),
                    const Text("Open Grounds"),
                    Radio<String>(
                      value: "Lounge",
                      groupValue: _venueType,
                      onChanged: (value) {
                        setState(() {
                          _venueType = value!;
                        });
                      },
                    ),
                    const Text("Lounge"),
                  ],
                ),
                const SizedBox(height: 8),
                // Text field for Location.
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
                const SizedBox(height: 8),
                // Text field for Timings.
                TextField(
                  controller: _timingsController,
                  decoration: const InputDecoration(labelText: "Timings"),
                ),
                const SizedBox(height: 8),
                // Text field for Contact Number.
                TextField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: "Contact Number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _storeVenueData,
                  child: const Text("Submit Venue Data"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
