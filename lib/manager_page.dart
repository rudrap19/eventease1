import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ManagerDesc.dart'; // Make sure this file exists and is correctly named

class ManagersPage extends StatelessWidget {
  const ManagersPage({Key? key}) : super(key: key);

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
                child: Center(
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

  Widget _buildManagersGrid(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('manager_data1').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final managers = snapshot.data!.docs;

        return GridView.count(
          padding: const EdgeInsets.only(bottom: 12),
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: managers.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final String name = data['name'] ?? 'Unnamed Manager';
            final List<dynamic> imageUrls = data['imageUrls'] ?? [];
            final String imageUrl = imageUrls.isNotEmpty
                ? imageUrls[0]
                : 'https://placehold.co/300x300';

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagerDesc(managerData: data),
                  ),
                );
              },
              child: _buildManagerCard(
                imageUrl: imageUrl,
                name: name,
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
        title: const Text("Managers"),
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
              child: _buildManagersGrid(context),
            ),
          ),
        ],
      ),
    );
  }
}
