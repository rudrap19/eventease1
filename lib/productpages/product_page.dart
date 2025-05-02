import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ProductDesc.dart';

class EventProductStorePage extends StatelessWidget {
  const EventProductStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Event Product Store',
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Icon(Icons.shopping_cart, color: Colors.white),
        ],
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
            // Adjusted top padding for better spacing
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 32,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Space below AppBar
                const SizedBox(height: 16.0),
                // Search field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search party supplies...',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Featured section title
                const Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Reduced spacing between title and grid
                // Product grid
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('productdata').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    final products = snapshot.data!.docs;
                    return GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.75,
                      children: products.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final imageUrl = (data['imageUrls'] ?? ['https://placehold.co/150x100'])[0] as String;
                        final name = data['productName']?.toString() ?? 'No Name';
                        // Clean and parse price stored as string
                        final rawPrice = data['price']?.toString() ?? '0';
                        final numericString = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
                        final price = int.tryParse(numericString) ?? 0;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDesc(productData: data),
                              ),
                            );
                          },
                          child: ProductCard(
                            imageUrl: imageUrl,
                            name: name,
                            rating: 4.5,
                            price: price,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final int price;

  const ProductCard({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8.0),
          Text(
            name,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(
            '₹$price',
            style: const TextStyle(fontSize: 12.0, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
