import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VenuePage extends StatelessWidget {
  const VenuePage({Key? key}) : super(key: key);

  // Helper method to build a venue card.
  Widget _buildVenueCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the grid view displaying venue cards.
  Widget _buildVenuesGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildVenueCard(
            imageUrl: 'https://placehold.co/300x300',
            title: 'Central Park',
            subtitle: 'New York, NY',
          ),
          _buildVenueCard(
            imageUrl: 'https://placehold.co/300x300',
            title: 'Downtown Arena',
            subtitle: 'Los Angeles, CA',
          ),
          _buildVenueCard(
            imageUrl: 'https://placehold.co/300x300',
            title: 'City Square',
            subtitle: 'Chicago, IL',
          ),
          _buildVenueCard(
            imageUrl: 'https://placehold.co/300x300',
            title: 'Beachside',
            subtitle: 'Miami, FL',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Venue"),
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
          _buildVenuesGrid(),
        ],
      ),
    );
  }
}

/*
The following is the complete user form code from the original file, now included as a comment for reference.

/// A stateful widget that contains the user information form.
class UserFormSection extends StatefulWidget {
  const UserFormSection({Key? key}) : super(key: key);

  @override
  _UserFormSectionState createState() => _UserFormSectionState();
}

class _UserFormSectionState extends State<UserFormSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _locationController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  // Pick an image from the gallery.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Handle form submission: upload image to Firebase Storage and save user details in Firestore.
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image to Firebase Storage.
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Save user details in Firestore along with the image URL.
      await FirebaseFirestore.instance.collection("users").add({
        "name": _nameController.text.trim(),
        "dob": _dobController.text.trim(),
        "gender": _genderController.text.trim(),
        "location": _locationController.text.trim(),
        "imageUrl": imageUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data uploaded successfully!")),
      );

      // Optionally, clear the form after a successful upload.
      _formKey.currentState!.reset();
      setState(() {
        _imageFile = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading data: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Image picker.
                  GestureDetector(
                    onTap: _pickImage,
                    child: _imageFile != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_imageFile!),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.camera_alt, size: 40),
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  // Name field.
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your name" : null,
                  ),
                  const SizedBox(height: 16.0),
                  // Date of Birth field.
                  TextFormField(
                    controller: _dobController,
                    decoration: const InputDecoration(
                      labelText: "Date of Birth",
                      hintText: "YYYY-MM-DD",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your date of birth" : null,
                  ),
                  const SizedBox(height: 16.0),
                  // Gender field.
                  TextFormField(
                    controller: _genderController,
                    decoration: const InputDecoration(
                      labelText: "Gender",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your gender" : null,
                  ),
                  const SizedBox(height: 16.0),
                  // Location field.
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter your location" : null,
                  ),
                  const SizedBox(height: 24.0),
                  // Submit button.
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          );
  }
}
*/
