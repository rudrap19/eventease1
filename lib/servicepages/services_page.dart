import 'package:flutter/material.dart';

/*
-------------------------------------------------
Old ServicesPage Code (Saved for Reference):

const ServicesPage({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Service Details'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {},
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Service image with icons overlay
          Stack(
            children: [
              Image.network(
                'https://placehold.co/600x400',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 16,
                left: 16,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const Positioned(
                top: 16,
                right: 16,
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service title
                const Text(
                  'Royal Catering Services',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Service category and rating
                Row(
                  children: [
                    const Text(
                      'Catering Service',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: const [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        Text('4.8'),
                        SizedBox(width: 8),
                        Text(
                          '(200)',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Service highlights
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHighlight(Icons.business_center, '10+ Years Experience'),
                    _buildHighlight(Icons.people, '1000+ Events'),
                    _buildHighlight(Icons.restaurant, 'Multi-cuisine Expert'),
                  ],
                ),
                const SizedBox(height: 16),
                // About section
                const Text(
                  'About',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Premium catering service with 10+ years of experience in wedding and corporate events. Specializing in multi-cuisine menu designing and execution with a professional team.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                // Portfolio section
                _buildSectionTitle('Portfolio', 'View All'),
                const SizedBox(height: 8),
                _buildPortfolioGrid(),
                const SizedBox(height: 16),
                // Pricing packages
                _buildSectionTitle('Pricing Packages', ''),
                const SizedBox(height: 8),
                const PricingPackage(
                    title: 'Basic',
                    details: ['Up to 100 guests', 'Buffet', 'Basic decoration'],
                    price: '₹9990'),
                const PricingPackage(
                    title: 'Premium',
                    details: ['100-200 guests', 'Buffet', 'Premium decoration', 'Service staff'],
                    price: '₹14500'),
                const PricingPackage(
                    title: 'Luxury',
                    details: ['200+ guests', 'Buffet', 'Luxury decoration', 'Service staff', 'Event planning'],
                    price: '₹24990'),
                const SizedBox(height: 16),
                // Reviews section
                _buildSectionTitle('Reviews', 'View All'),
                const SizedBox(height: 8),
                const Review(
                    name: 'Sarah Johnson',
                    rating: 4.5,
                    comment: 'Amazing service! The food was delicious and presentation was perfect.'),
                const Review(
                    name: 'Michael Chen',
                    rating: 5.0,
                    comment: 'Professional team, great variety of dishes. Highly recommended!'),
                const SizedBox(height: 16),
                // CTA button
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Check Availability'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildHighlight(IconData icon, String text) {
  return Column(
    children: [
      Icon(icon),
      const SizedBox(height: 4),
      Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

Widget _buildSectionTitle(String title, String actionText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      if (actionText.isNotEmpty)
        Text(
          actionText,
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
    ],
  );
}

Widget _buildPortfolioGrid() {
  return GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    children: List.generate(6, (index) {
      return Image.network(
        'https://placehold.co/100x100',
        fit: BoxFit.cover,
      );
    }),
  );
}

class PricingPackage extends StatelessWidget {
  final String title;
  final List<String> details;
  final String price;

  const PricingPackage({
    Key? key,
    required this.title,
    required this.details,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...details.map((detail) => Text(detail)).toList(),
            const SizedBox(height: 8),
            Text(price,
                style: const TextStyle(color: Colors.green, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class Review extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;

  const Review({
    Key? key,
    required this.name,
    required this.rating,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const SizedBox(width: 4),
                Text('$rating'),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }
}
-------------------------------------------------
*/

// New Page: ServicesListPage
// This page displays a grid of service categories (e.g., Catering, Decorators, etc.)
// with boxes styled similarly to the product page.

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  final List<Map<String, String>> services = const [
    {
      'title': 'Catering',
      'imageUrl': 'https://placehold.co/150x150',
    },
    {
      'title': 'Decorators',
      'imageUrl': 'https://placehold.co/150x150',
    },
    {
      'title': 'Photography',
      'imageUrl': 'https://placehold.co/150x150',
    },
    {
      'title': 'Entertainment',
      'imageUrl': 'https://placehold.co/150x150',
    },
    {
      'title': 'Venue',
      'imageUrl': 'https://placehold.co/150x150',
    },
    {
      'title': 'Event Planning',
      'imageUrl': 'https://placehold.co/150x150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () {
                // Add navigation to a detailed service page if needed.
              },
              child: Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Service image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        service['imageUrl']!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Service title
                    Text(
                      service['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
