import 'package:flutter/material.dart';

class ManagersPage extends StatelessWidget {
  const ManagersPage({Key? key}) : super(key: key);

  // A static list of managers. You can update these details as needed.
  final List<Map<String, String>> managers = const [
    {
      "name": "Alice",
      "imageUrl": "https://placehold.co/300x300",
    },
    {
      "name": "Bob",
      "imageUrl": "https://placehold.co/300x300",
    },
    {
      "name": "Charlie",
      "imageUrl": "https://placehold.co/300x300",
    },
    {
      "name": "Diana",
      "imageUrl": "https://placehold.co/300x300",
    },
  ];

  // Helper widget to build a static manager card.
  Widget _buildManagerCard({
    required String imageUrl,
    required String name,
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
          children: [
            // Image section
            Expanded(
              flex: 2,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey,
                child: const Icon(Icons.person, size: 50),
              ),
            ),
            // Manager name
            Expanded(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a grid view of static manager cards.
  Widget _buildManagersGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: managers.map((manager) {
          return _buildManagerCard(
            imageUrl: manager["imageUrl"]!,
            name: manager["name"]!,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Managers"),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // The managers grid over the background
          _buildManagersGrid(),
        ],
      ),
    );
  }
}
