import 'package:flutter/material.dart';
import 'venue_page.dart';
import 'manager_page.dart';
import 'product_page.dart';
import 'services_page.dart';
import 'compare_page.dart'; // Import Compare page

/// HomeContentPage displays the search bar, categories, trending venues, and featured products.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search events, venues, service',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  /// Function to create clickable category cards
  Widget _buildClickableCategoryCard({
    required BuildContext context,
    required Widget page, // Page to navigate to
    required IconData icon,
    required Color color,
    required String text,
    required Color iconColor,
    bool isFullWidth = false,
  }) {
    Widget cardContent = Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(height: 12.0),
          Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: isFullWidth
          ? SizedBox(
        height: 150,
        width: double.infinity,
        child: cardContent,
      )
          : AspectRatio(
        aspectRatio: 1,
        child: cardContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Home Page'), // ✅ Changed from "Responsive Design" to "Home Page"
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Search Bar
            _buildSearchBar(),

            // Categories Section with Clickable Cards
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildClickableCategoryCard(
                        context: context,
                        page: const ManagersPage(), // Redirect to Managers Page
                        icon: Icons.calendar_today,
                        color: Colors.blue.shade100,
                        text: 'Event Management',
                        iconColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildClickableCategoryCard(
                        context: context,
                        page: const ServicesPage(), // Redirect to Services Page
                        icon: Icons.person,
                        color: Colors.purple.shade100,
                        text: 'Individual Service',
                        iconColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildClickableCategoryCard(
                        context: context,
                        page: const VenuePage(), // Redirect to Venue Page
                        icon: Icons.location_on,
                        color: Colors.green.shade100,
                        text: 'Venue',
                        iconColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildClickableCategoryCard(
                        context: context,
                        page: const EventProductStorePage(), // Redirect to Products Page
                        icon: Icons.shopping_cart,
                        color: Colors.yellow.shade100,
                        text: 'Product',
                        iconColor: Colors.yellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildClickableCategoryCard(
                  context: context,
                  page: const ComparePage(), // Redirect to Compare Page
                  icon: Icons.star,
                  color: Colors.pink.shade100,
                  text: 'Compare',
                  iconColor: Colors.pink,
                  isFullWidth: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
