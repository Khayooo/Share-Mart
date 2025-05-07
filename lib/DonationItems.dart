import 'package:flutter/material.dart';
// import 'package:fyp_donation/AddItemScreen.dart';
// import 'package:fyp_donation/HomePage.dart';
import 'AccountScreen.dart';
// import 'AddItemScreen.dart';
// import 'HomePage.dart';
import 'ItemDetailsScreen.dart';

class DonationItems extends StatelessWidget {
  const DonationItems({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    final List<Map<String, dynamic>> donationItems = [
      {
        "image": "images/Laptop.png",
        "title": "Laptop",
        "distance": "1.5 km away",
        "description": "Dell Inspiron 15\n8GB RAM, 256GB SSD\nGood condition",
        "donor": {
          "name": "Ahmed Khan",
          "address": "University Road",
          "cnic": "12345-6789012"
        }
      },
      {
        "image": "images/Chair.png",
        "title": "Office Chair",
        "distance": "2.3 km away",
        "description": "Ergonomic office chair\nAdjustable height\nLike new",
        "donor": {
          "name": "Fatima Ali",
          "address": "Cantt Area",
          "cnic": "54321-9876543"
        }
      },
      {
        "image": "images/Books.png",
        "title": "Book Collection",
        "distance": "0.8 km away",
        "description": "Various fiction books\nGood condition\n20+ titles",
        "donor": {
          "name": "Usman Malik",
          "address": "Peshawar Road",
          "cnic": "98765-4321098"
        }
      },
      {
        "image": "images/Kitchen.png",
        "title": "Kitchen Set",
        "distance": "3.1 km away",
        "description": "Complete kitchen set\nPots, pans, utensils\nGood condition",
        "donor": {
          "name": "Ayesha Rehman",
          "address": "Warsak Road",
          "cnic": "45678-9012345"
        }
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text('Donation Items',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLargeScreen ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: donationItems.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(
                      item: donationItems[index],
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
                          donationItems[index]['image'],
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
                          Text(
                            donationItems[index]['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14,
                                  color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text(
                                donationItems[index]['distance'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
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
      bottomNavigationBar: _buildBottomNavBar(context, 1), // Highlight Donations
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          elevation: 10,
          onTap: (index) {

            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 4) {
              Navigator.push(
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
        ),
      ),
    );
  }
}