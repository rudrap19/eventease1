import 'package:flutter/material.dart';
import 'venuepages/venue_page.dart';
import 'manager_page.dart';
import 'productpages/product_page.dart';
import 'servicepages/services_page.dart';
import 'compare_page.dart';
import 'auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContentPage(),
    VenuePage(),
    ManagersPage(),
    EventProductStorePage(),
    ServicesPage(),
    ComparePage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          _pages[_currentIndex],
        ],
      ),
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

class HomeContentPage extends StatelessWidget {
  const HomeContentPage({Key? key}) : super(key: key);

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

    return isFullWidth
        ? SizedBox(height: 150, width: double.infinity, child: cardContent)
        : AspectRatio(aspectRatio: 1, child: cardContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSearchBar(),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ManagersPage()),
                          );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.calendar_today,
                          color: Colors.blue.shade100,
                          text: 'Event Management',
                          iconColor: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ServicesPage()),
                          );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.person,
                          color: Colors.purple.shade100,
                          text: 'Individual Service',
                          iconColor: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VenuePage()),
                          );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.location_on,
                          color: Colors.green.shade100,
                          text: 'Venue',
                          iconColor: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EventProductStorePage()),
                          );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.shopping_cart,
                          color: Colors.yellow.shade100,
                          text: 'Product',
                          iconColor: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ComparePage()),
                    );
                  },
                  child: _buildCategoryCard(
                    icon: Icons.star,
                    color: Colors.pink.shade100,
                    text: 'Compare',
                    iconColor: Colors.pink,
                    isFullWidth: true,
                  ),
                ),


              ],
            ),
            const SizedBox(height: 24),
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
            Center(
              child: TextButton(
                onPressed: () {
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
