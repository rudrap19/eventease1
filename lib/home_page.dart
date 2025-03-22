import 'package:flutter/material.dart';
import 'venue_page.dart';      // Ensure this file exists
import 'manager_page.dart';    // Ensure this file exists
import 'product_page.dart';
/// A reusable scaffold that manages bottom navigation and page switching.
class CustomBottomNavScaffold extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> items;
  final int initialIndex;

  const CustomBottomNavScaffold({
    Key? key,
    required this.pages,
    required this.items,
    this.initialIndex = 0,
  })  : assert(
  pages.length == items.length,
  "The number of pages must match the number of navigation items.",
  ),
        super(key: key);

  @override
  CustomBottomNavScaffoldState createState() => CustomBottomNavScaffoldState();
}

class CustomBottomNavScaffoldState extends State<CustomBottomNavScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: widget.items,
      ),
    );
  }
}

/// Main HomePage using the custom bottom navigation scaffold.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavScaffold(
      pages: const [
        HomeContentPage(),
        VenuePage(),       // Points to venue_page.dart
        ManagersPage(),    // Points to manager_page.dart
        ProductsPage(),
        ServicesPage(),
        ComparePage(),     // New Compare page
      ],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Venue',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervisor_account),
          label: 'Managers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.miscellaneous_services),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Compare',
        ),
      ],
    );
  }
}

/// HomeContentPage displays the search bar, categories, trending venues, and featured products.
/// Here we use a ListView for scrolling, which adapts the content height dynamically.
class HomeContentPage extends StatelessWidget {
  const HomeContentPage({Key? key}) : super(key: key);

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

  Widget _buildCategoryCard({
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

    return isFullWidth
        ? SizedBox(
      height: 150,
      width: double.infinity,
      child: cardContent,
    )
        : AspectRatio(
      aspectRatio: 1,
      child: cardContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Responsive Design'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Search Bar
            _buildSearchBar(),
            // Categories Section
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        icon: Icons.calendar_today,
                        color: Colors.blue.shade100,
                        text: 'Event Management',
                        iconColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCategoryCard(
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
                      child: _buildCategoryCard(
                        icon: Icons.location_on,
                        color: Colors.green.shade100,
                        text: 'Venue',
                        iconColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCategoryCard(
                        icon: Icons.shopping_cart,
                        color: Colors.yellow.shade100,
                        text: 'Product',
                        iconColor: Colors.yellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCategoryCard(
                  icon: Icons.star,
                  color: Colors.pink.shade100,
                  text: 'Compare',
                  iconColor: Colors.pink,
                  isFullWidth: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Trending Venues Section (location details removed)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Venues',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                VenueCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Central Park',
                  subtitle: '',
                ),
                VenueCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Downtown Arena',
                  subtitle: '',
                ),
                VenueCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'City Square',
                  subtitle: '',
                ),
                VenueCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Beachside',
                  subtitle: '',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Featured Products Section (Pricing removed)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                ProductCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Product 1',
                ),
                ProductCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Product 2',
                ),
                ProductCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Product 3',
                ),
                ProductCard(
                  imageUrl: 'https://placehold.co/300x300',
                  title: 'Product 4',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A card widget representing a trending venue.
class VenueCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const VenueCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show subtitle if it's not empty.
    List<Widget> infoWidgets = [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ];
    if (subtitle.isNotEmpty) {
      infoWidgets.add(const SizedBox(height: 4));
      infoWidgets.add(Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: infoWidgets,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A card widget representing a featured product (without pricing).
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
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
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
}

/// Placeholder page for Products.
class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const Center(child: Text("Products Page Content")),
    );
  }
}

/// Placeholder page for Services.
class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
      ),
      body: const Center(child: Text("Services Page Content")),
    );
  }
}

/// ComparePage: displayed when the user taps the "Compare" tab.
class ComparePage extends StatelessWidget {
  const ComparePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compare"),
      ),
      body: const Center(
        child: Text("Compare Page Content"),
      ),
    );
  }
}
