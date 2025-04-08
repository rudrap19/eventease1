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
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _plotNoController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _timingsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String _venueType = "Club";

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

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

  Future<void> _storeVenueData() async {
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }

    try {
      await FirebaseFirestore.instance.collection('venuedata').add({
        'name': _nameController.text.trim(),
        'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
        'venueType': _venueType,
        'plotNo': _plotNoController.text.trim(),
        'area': _areaController.text.trim(),
        'town': _townController.text.trim(),
        'city': _cityController.text.trim(),
        'timings': _timingsController.text.trim(),
        'contact': _contactController.text.trim(),
        'imageUrls': _uploadedImageUrls,
      });
      print("Venue data stored successfully.");

      _nameController.clear();
      _capacityController.clear();
      _plotNoController.clear();
      _areaController.clear();
      _townController.clear();
      _cityController.clear();
      _timingsController.clear();
      _contactController.clear();
      setState(() {
        _selectedImages = [];
        _uploadedImageUrls = [];
        _venueType = "Club";
      });
    } catch (e) {
      print("Error storing venue data: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _plotNoController.dispose();
    _areaController.dispose();
    _townController.dispose();
    _cityController.dispose();
    _timingsController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Venue Sign Up Form"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Venue Name"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: "Capacity"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
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
                TextField(
                  controller: _plotNoController,
                  decoration: const InputDecoration(labelText: "Shop No / Plot No"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _areaController,
                  decoration: const InputDecoration(labelText: "Street / Area"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _townController,
                  decoration: const InputDecoration(labelText: "Town"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: "City"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _timingsController,
                  decoration: const InputDecoration(labelText: "Timings"),
                ),
                const SizedBox(height: 8),
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