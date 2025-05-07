import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'AccountScreen.dart';
import 'ItemDetailsScreen.dart';
import 'HomePage.dart';
import 'DonationItems.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    timeDilation = 1.5;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItems = [
      {
        "image": "images/Airpod.png",
        "title": "AirPods Pro (2nd Generation)",
        "distance": "0.5 km away",
        "price": "45,000",
        "isFavorited": true,
        "description": "Brand new sealed box with warranty",
        "donor": {
          "name": "Noman Ashraf",
          "address": "Verpal Chartha",
          "cnic": "34104-**********"
        }
      },
      {
        "image": "images/Laptop.png",
        "title": "MacBook Pro M1 2020",
        "distance": "1.2 km away",
        "price": "185,000",
        "isFavorited": true,
        "description": "16GB RAM, 512GB SSD, Excellent condition",
        "donor": {
          "name": "Ali Khan",
          "address": "University Town",
          "cnic": "12345-6789012"
        }
      },
      {
        "image": "images/Book_1.png",
        "title": "Advanced Physics Textbook",
        "distance": "0.8 km away",
        "price": "1,200",
        "isFavorited": true,
        "description": "Latest edition, barely used",
        "donor": {
          "name": "Sara Ahmed",
          "address": "Hayatabad Phase 5",
          "cnic": "98765-4321098"
        }
      },
      {
        "image": "images/Chair.png",
        "title": "Ergonomic Office Chair",
        "distance": "2.5 km away",
        "price": "12,500",
        "isFavorited": true,
        "description": "Like new, adjustable height and tilt",
        "donor": {
          "name": "Usman Malik",
          "address": "Warsak Road",
          "cnic": "45678-9012345"
        }
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Saved Items",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: savedItems.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.deepPurple.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  "No saved items yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the heart icon to save items",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72, // Slightly adjusted for mobile
              ),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsScreen(
                          item: savedItems[index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.asset(
                              savedItems[index]['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20, // Fixed height for title
                                child: Text(
                                  savedItems[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 14, // Slightly smaller font
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 12, // Smaller icon
                                      color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    savedItems[index]['distance'],
                                    style: TextStyle(
                                      fontSize: 11, // Smaller font
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 80),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Rs. ${savedItems[index]['price']}",
                                      style: TextStyle(
                                        fontSize: 11, // Smaller font
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(Icons.favorite,
                                        size: 18, // Smaller icon
                                        color: Colors.red.shade400),
                                    onPressed: () {
                                      setState(() {
                                        savedItems.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Removed from saved items'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 4),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey.shade500,
      backgroundColor: Colors.white,
      showUnselectedLabels: true,
      elevation: 10,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DonationItems()),
          );
        } else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AccountScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: "Donations",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Chats",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Account",
        ),
      ],
    );
  }
}