import 'package:flutter/material.dart';
import 'venuepages/venue_page.dart';
import 'manager_page.dart';
import 'productpages/product_page.dart';
import 'servicepages/services_page.dart';
import 'compare_page.dart';
import 'auth_service.dart'; // For handling sign-out functionality

/// The main HomePage widget that uses a bottom navigation bar to switch  
/// between different pages (Home, Venue, Managers, Products, Services, and Compare).
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// The state of HomePage where the current tab index is maintained.
class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  // List of pages corresponding to the bottom navigation items.
  final List<Widget> _pages = const [
    HomeContentPage(),
    VenuePage(),
    ManagersPage(),
    EventProductStorePage(),
    ServicesPage(),
    ComparePage(),
  ];

  /// Updates the current index when a bottom navigation item is tapped.
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a Stack allows us to place the background image behind the page content.
      body: Stack(
        children: [
          // Background image covering the entire screen.
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // The content of the currently selected page.
          _pages[_currentIndex],
        ],
      ),
      // Bottom navigation bar for switching between pages.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
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
      ),
    );
  }
}

/// The HomeContentPage displays the main content for the Home tab, which includes:
/// - A search bar
/// - Category cards for navigation
/// - Sections for Trending Venues and Featured Products
/// - A Logout button
class HomeContentPage extends StatelessWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  /// Builds a search bar widget at the top of the page.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search events, venues, services',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: const Icon(Icons.search),
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

    // Return a full-width card or a square card based on the flag.
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
      // Transparent background lets the main background image from HomePage show through.
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // The content is wrapped in a SafeArea and a ListView for scrolling.
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Search bar section
            _buildSearchBar(),

            // Categories Section: a grid of cards for different categories.
            Column(
              children: [
                // First row with two category cards.
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
                // Second row with two more cards.
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
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // A full-width card for the Compare category.
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

            // Trending Venues Section header.
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending Venues',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Grid view showing trending venues using custom VenueCard widgets.
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

            // Featured Products Section header.
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Featured Products',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Grid view for featured products using custom ProductCard widgets.
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
            const SizedBox(height: 24),

            // Logout Button: Allows the user to sign out.
            Center(
              child: TextButton(
                onPressed: () {
                  // Calls the signout method from AuthService.
                  AuthService().signout(context: context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// A custom card widget for displaying a trending venue.
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
    // Build a list of text widgets for the title and subtitle.
    List<Widget> infoWidgets = [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    ];

    // Add subtitle text if it's not empty.
    if (subtitle.isNotEmpty) {
      infoWidgets.add(const SizedBox(height: 4));
      infoWidgets.add(
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      );
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
            // Image section takes up two-thirds of the card.
            Expanded(
              flex: 2,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Text section for title/subtitle.
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

/// A custom card widget for displaying a featured product.
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
            // Image section.
            Expanded(
              flex: 2,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Title text section.
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
}
