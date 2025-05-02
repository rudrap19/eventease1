import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'venuedesc.dart';

class VenuePage extends StatelessWidget {
  const VenuePage({Key? key}) : super(key: key);

  Widget _buildVenueCard({
    required String imageUrl,
    required String title,
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
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: venues.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final String name = data['name'] ?? 'Unnamed Venue';
            final List<dynamic> imageUrls = data['imageUrls'] ?? [];
            final String imageUrl = imageUrls.isNotEmpty
                ? imageUrls[0]
                : 'https://placehold.co/300x300';

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VenueDesc(venueData: data),
                  ),
                );
              },
              child: _buildVenueCard(
                imageUrl: imageUrl,
                title: name,
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
