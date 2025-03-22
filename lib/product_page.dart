import 'package:flutter/material.dart';

/// The main products page for the event product store.
class EventProductStorePage extends StatelessWidget {
  const EventProductStorePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allow the background image to extend beneath the app bar.
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Make the AppBar transparent so the background image is visible.
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Back arrow to navigate back to the previous screen.
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // Title and a shopping cart icon.
        title: Text(
          'Event Product Store',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Icon(Icons.shopping_cart, color: Colors.white),
        ],
      ),
      body: Stack(
        children: [
          // Background image covers the entire screen.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // A semi-transparent black overlay to ensure text readability.
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // The main content is scrollable.
          SingleChildScrollView(
            child: Padding(
              // Add padding to keep content away from screen edges and the AppBar.
              padding: EdgeInsets.only(
                top: kToolbarHeight + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A search bar container with rounded corners.
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search party supplies...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // A row of category buttons.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CategoryButton(label: 'All', isSelected: true),
                      CategoryButton(label: 'Party Poppers'),
                      CategoryButton(label: 'Party Guns'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  // A special offer section with a gradient background.
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.pink],
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A row that displays offer details alongside an icon.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text details for the special offer.
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Special Party Bundle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Get 30% off on selected items',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Icon(Icons.tag, color: Colors.white, size: 30.0),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        // Button to shop the special offer.
                        ElevatedButton(
                          onPressed: () {
                            // Define your action for "Shop Now" here.
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.purple, backgroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                          child: Text('Shop Now'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Header for the Featured Products section.
                  Text(
                    'Featured Products',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Grid displaying featured products.
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
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
                  SizedBox(height: 16.0),
                  // Header for the Popular Right Now section.
                  Text(
                    'Popular Right Now',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Grid displaying popular products.
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      ProductCard(
                        imageUrl: 'https://placehold.co/150x100',
                        name: 'Party Starter Bundle',
                        rating: 4.3,
                        price: 200,
                      ),
                      ProductCard(
                        imageUrl: 'https://placehold.co/150x100',
                        name: 'Premium Flower Mix',
                        rating: 4.6,
                        price: 300,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A custom button widget used for the category options.
class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  CategoryButton({
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle category selection here.
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.grey[600], backgroundColor: isSelected ? Colors.red : Colors.grey[200],
        shape: StadiumBorder(),
      ),
      child: Text(label),
    );
  }
}

/// A custom widget that displays an individual product card.
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;
  final int price;

  ProductCard({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // Adds a subtle shadow for a lifted effect.
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
          // Display the product image.
          Image.network(
            imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          // Display the product name.
          Text(
            name,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          // Display the product price.
          Text(
            '₹$price',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
