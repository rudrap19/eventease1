import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../RegistrationPage.dart';

class ServiceDesc extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const ServiceDesc({Key? key, required this.serviceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = serviceData['name'] ?? 'Unnamed Service';
    final String category = serviceData['category'] ?? 'Unknown Category';
    final String contact = serviceData['contact'] ?? 'No contact info';
    final String street = serviceData['street'] ?? '';
    final String locality = serviceData['locality'] ?? '';
    final String city = serviceData['city'] ?? '';
    final String pincode = serviceData['pincode'] ?? '';
    final List<dynamic> imageUrlsDynamic = serviceData['imageUrls'] ?? [];
    final List<String> imageUrls = imageUrlsDynamic.map((e) => e.toString()).toList();

    final String fullAddress = [street, locality, city, pincode]
        .where((e) => e.isNotEmpty)
        .join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (imageUrls.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items: imageUrls.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                  )
                else
                  Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: Text("No images available")),
                  ),
                const SizedBox(height: 16),

                Text(
                  name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),

                _buildInfoRow(Icons.category, 'Category: $category'),
                _buildInfoRow(Icons.phone, 'Contact: $contact'),
                _buildInfoRow(Icons.location_on, fullAddress),

                if (serviceData['description'] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    serviceData['description'],
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],

                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //Navigator.push(
                        //context,
                        //MaterialPageRoute(builder: (context) => const RegistrationPage()),);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Book Now", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
