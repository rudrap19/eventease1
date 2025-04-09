import 'package:flutter/material.dart';
import '../RegistrationPage.dart'; // Import RegistrationPage

class EventProductStorePage extends StatelessWidget {
  const EventProductStorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Event Product Store', style: TextStyle(color: Colors.white)),
        actions: const [
          Icon(Icons.shopping_cart, color: Colors.white),
        ],
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
          // Overlay
          Container(color: Colors.black.withOpacity(0.5)),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: kToolbarHeight + 24,
              left: 16,
              right: 16,
              bottom: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
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

                const SizedBox(height: 16.0),

                const Text(
                  'Featured Products',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16.0),

                // Featured products grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: const [
                    ProductCard(
                      imageUrl: 'https://placehold.co/150x100',
                      name: 'Confetti Party Popper',
                      rating: 4.5,
                      price: 100,
                    ),
                    ProductCard(
                      imageUrl: 'https://placehold.co/150x100',
                      name: 'Celebration Party Gun',
                      rating: 4.8,
                      price: 2000,
                    ),
                    ProductCard(
                      imageUrl: 'https://placehold.co/150x100',
                      name: 'Rose Bouquet Mix',
                      rating: 4.7,
                      price: 300,
                    ),
                    ProductCard(
                      imageUrl: 'https://placehold.co/150x100',
                      name: 'Rainbow Popper Set',
                      rating: 4.6,
                      price: 800,
                    ),
                  ],
                ),

                const SizedBox(height: 24.0),

                // Book Venue Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Book Venue", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const CategoryButton({required this.label, this.isSelected = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.grey[600],
        backgroundColor: isSelected ? Colors.red : Colors.grey[200],
        shape: const StadiumBorder(),
      ),
      child: Text(label),
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
          Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
          const SizedBox(height: 8.0),
          Text(name, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4.0),
          Text('₹$price', style: const TextStyle(fontSize: 12.0, color: Colors.red)),
        ],
      ),
    );
  }
}
