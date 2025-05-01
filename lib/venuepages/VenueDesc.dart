// VenueDesc.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../RegistrationPage.dart';

class VenueDesc extends StatelessWidget {
  final Map<String, dynamic> venueData;

  const VenueDesc({Key? key, required this.venueData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract and convert data
    final String name = venueData['name']?.toString() ?? 'Unnamed Venue';
    final String capacity = venueData['capacity']?.toString() ?? 'N/A';
    final String venueType = venueData['venueType']?.toString() ?? 'N/A';
    final String timings = venueData['timings']?.toString() ?? 'N/A';
    final String contact = venueData['contact']?.toString() ?? 'N/A';

    final List<dynamic> imageUrlsDynamic = venueData['images'] ?? [];
    final List<String> imageUrls = imageUrlsDynamic.map((e) => e.toString()).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          // Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Image carousel or placeholder
                if (imageUrls.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items: imageUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  )
                else
                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.photo, size: 48, color: Colors.white54),
                    ),
                  ),

                const SizedBox(height: 24),

                // Info rows
                _buildInfoRow(Icons.people, 'Capacity: $capacity'),
                _buildInfoRow(Icons.category, 'Type: $venueType'),
                _buildInfoRow(Icons.access_time, 'Timings: $timings'),
                _buildInfoRow(Icons.phone, 'Contact: $contact'),

                const SizedBox(height: 32),

                // Book button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationPage(bookingName: name),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Book Now', style: TextStyle(fontSize: 18)),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
