import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const ProductSignUpFormApp());
}

class ProductSignUpFormApp extends StatelessWidget {
  const ProductSignUpFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Sign Up Form',
      home: ProductSignUpForm(),
    );
  }
}

class ProductSignUpForm extends StatefulWidget {
  const ProductSignUpForm({super.key});

  @override
  State<ProductSignUpForm> createState() => _ProductSignUpFormState();
}

class _ProductSignUpFormState extends State<ProductSignUpForm> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _registeredAddressController = TextEditingController();
  final TextEditingController _deliveryAddressController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

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
          .child('product_uploads')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      _uploadedImageUrls.add(imageUrl);
    }
  }

  Future<void> _storeProductData() async {
    if (_selectedImages.isNotEmpty) {
      await _uploadImages();
    }

    await FirebaseFirestore.instance.collection('productdata').add({
      'productName': _productNameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'quantity': _quantityController.text.trim(),
      'price': _priceController.text.trim(),
      'sellerName': _sellerNameController.text.trim(),
      'registeredAddress': _registeredAddressController.text.trim(),
      'deliveryAddress': _deliveryAddressController.text.trim(),
      'gstNumber': _gstController.text.trim(),
      'imageUrls': _uploadedImageUrls,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product submitted successfully!")),
    );

    _productNameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _priceController.clear();
    _sellerNameController.clear();
    _registeredAddressController.clear();
    _deliveryAddressController.clear();
    _gstController.clear();

    setState(() {
      _selectedImages.clear();
      _uploadedImageUrls.clear();
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _sellerNameController.dispose();
    _registeredAddressController.dispose();
    _deliveryAddressController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Sign Up Form")),
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
                  "Upload Product Images",
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
                  controller: _productNameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: "Quantity Available"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: "Price (in ₹)"),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Seller Info",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(),

                TextField(
                  controller: _sellerNameController,
                  decoration: const InputDecoration(labelText: "Seller / Company Name"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _registeredAddressController,
                  decoration: const InputDecoration(labelText: "Registered Address"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _deliveryAddressController,
                  decoration: const InputDecoration(labelText: "Delivery/Fulfillment Address"),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _gstController,
                  decoration: const InputDecoration(labelText: "GST Number"),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _storeProductData,
                  child: const Text("Submit Product"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
