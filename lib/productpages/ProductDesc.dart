import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../RegistrationPage.dart';
import 'paymentapi.dart';  // import the payment page
import 'productcart.dart';  // import the cart page and cartItems list

class ProductDesc extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDesc({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = productData['productName'] ?? 'Unnamed Product';
    final String description = productData['description'] ?? 'No description';
    final String quantity = productData['quantity']?.toString() ?? 'N/A';
    final String price = productData['price']?.toString() ?? 'N/A';
    final String seller = productData['sellerName'] ?? 'Unknown Seller';
    final List<dynamic> imageUrlsDynamic = productData['imageUrls'] ?? [];
    final List<String> imageUrls = imageUrlsDynamic.map((e) => e.toString()).toList();

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
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.store, 'Seller: $seller'),
                _buildInfoRow(Icons.inventory, 'Available: $quantity pcs'),
                _buildInfoRow(Icons.price_check, 'Price: ₹$price'),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                // Two buttons side by side: Add to Cart and Buy Now
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add product to global cart list
                          cartItems.add(productData);
                          // Navigate to cart page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductCart(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to payment page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentApi(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
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
