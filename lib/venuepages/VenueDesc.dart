import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VenueDesc extends StatelessWidget {
  final Map<String, dynamic> venueData;

  const VenueDesc({Key? key, required this.venueData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract venue details from the passed data.
    final String name = venueData['name'] ?? 'Unnamed Venue';
    final String location = venueData['location'] ?? 'No location provided';
    final String capacity = venueData['capacity']?.toString() ?? 'N/A';
    final String venueType = venueData['venueType'] ?? 'N/A';
    final String timings = venueData['timings'] ?? 'N/A';
    final String contact = venueData['contact'] ?? 'N/A';

    // Convert the dynamic list of image URLs to a List of strings.
    final List<dynamic> imageUrlsDynamic = venueData['imageUrls'] ?? [];
    final List<String> imageUrls =
    imageUrlsDynamic.map((e) => e.toString()).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      // Use ListView for scrolling content.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Carousel slider to display multiple images.
          if (imageUrls.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0, // Adjust the height of the carousel slider here.
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      // Wrap the image in a ClipRRect to provide rounded corners.
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12), // Change radius here.
                        child: Image.network(
                          url,
                          fit: BoxFit.cover, // Adjust how the image fits inside its container.
                          width: double.infinity, // Change width if needed.
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            )
          else
          // Display a placeholder if there are no images.
            Container(
              height: 250, // Same height as the carousel.
              color: Colors.grey[300],
              child: const Center(child: Text("No images available")),
            ),
          const SizedBox(height: 16),
          // Venue name
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Location row
          Row(
            children: [
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(location, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Capacity row
          Row(
            children: [
              const Icon(Icons.people, size: 20),
              const SizedBox(width: 4),
              Text("Capacity: $capacity", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          // Venue type row
          Row(
            children: [
              const Icon(Icons.category, size: 20),
              const SizedBox(width: 4),
              Text("Type: $venueType", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          // Timings row
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 4),
              Text("Timings: $timings", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          // Contact row
          Row(
            children: [
              const Icon(Icons.phone, size: 20),
              const SizedBox(width: 4),
              Text("Contact: $contact", style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          // Additional description if available.
          if (venueData['description'] != null)
            Text(
              venueData['description'],
              style: const TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}
