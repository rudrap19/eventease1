import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'venuedesc.dart';

class VenuePage extends StatelessWidget {
  const VenuePage({Key? key}) : super(key: key);

  // Helper method to build a venue card in a horizontal layout.
  Widget _buildVenueCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Change radius for rounded corners.
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4, // Adjust shadow blur.
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Left side: venue image.
            Expanded(
              flex: 2, // Adjust relative width of the image.
              child: Image.network(
                imageUrl,
                height: double.infinity, // Fills vertical space.
                fit: BoxFit.cover, // Change image fitting as needed.
              ),
            ),
            // Right side: venue details.
            Expanded(
              flex: 3, // Adjust relative width of the details section.
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Change inner padding.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Adjust title font size.
                      ),
                    ),
                    const SizedBox(height: 8), // Spacing between title and subtitle.
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14, // Adjust subtitle font size.
                        color: Colors.grey,
                      ),
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

  // Build the grid view dynamically from Firestore.
  Widget _buildVenuesGrid(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('venuedata').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final venues = snapshot.data!.docs;
        return GridView.count(
          padding: const EdgeInsets.only(bottom: 12),
          crossAxisCount: 1, // One card per row for a long rectangular look.
          childAspectRatio: 2.0, // Wider rectangular cards.
          mainAxisSpacing: 16, // Vertical spacing.
          crossAxisSpacing: 16, // Horizontal spacing.
          children: venues.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final String name = data['name'] ?? 'Unnamed Venue';
            final String location = data['location'] ?? '';
            final List<dynamic> imageUrls = data['imageUrls'] ?? [];
            final String imageUrl = imageUrls.isNotEmpty
                ? imageUrls[0]
                : 'https://placehold.co/300x300'; // Fallback image URL.

            // Wrap the card with an InkWell to make it clickable.
            return InkWell(
              onTap: () {
                // Redirect to VenueDesc page, passing necessary data.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VenueDesc(
                      venueData: data,
                    ),
                  ),
                );
              },
              child: _buildVenueCard(
                imageUrl: imageUrl,
                title: name,
                subtitle: location,
              ),
            );
          }).toList(),
        );
      },
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
                image: AssetImage("assets/bg.png"), // Background image.
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildVenuesGrid(context),
            ),
          ),
        ],
      ),
    );
  }
}
