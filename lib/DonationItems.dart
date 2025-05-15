import 'package:flutter/material.dart';
import 'AccountScreen.dart';
import 'HomePage.dart';
import 'ItemDetailsScreen.dart';
import 'AddItemScreen.dart';

class DonationItems extends StatelessWidget {
  const DonationItems({super.key});

  void _showAddItemDialog(BuildContext context) {
    bool sellChecked = false;
    bool donateChecked = false;
    bool exchangeChecked = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Select Item Type",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text("Sell Product"),
                    value: sellChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        sellChecked = value!;
                        if (sellChecked) {
                          donateChecked = false;
                          exchangeChecked = false;
                        }
                      });
                    },
                    activeColor: Colors.deepPurple,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text("Donate Product"),
                    value: donateChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        donateChecked = value!;
                        if (donateChecked) {
                          sellChecked = false;
                          exchangeChecked = false;
                        }
                      });
                    },
                    activeColor: Colors.deepPurple,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text("Exchange Product"),
                    value: exchangeChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        exchangeChecked = value!;
                        if (exchangeChecked) {
                          sellChecked = false;
                          donateChecked = false;
                        }
                      });
                    },
                    activeColor: Colors.deepPurple,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (sellChecked || donateChecked || exchangeChecked) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemScreen(
                            itemType: sellChecked
                                ? "Sell"
                                : donateChecked
                                ? "Donate"
                                : "Exchanges",
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    final List<Map<String, dynamic>> donationItems = [
      {
        "image": "images/Laptop.png",
        "title": "Laptop",
        "distance": "1.5 km away",
        "price": "Free",
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
        "price": "Free",
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
        "price": "Free",
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
        "price": "Free",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
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
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              donationItems[index]['price'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
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
            if (index == currentIndex) return;

            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                break;
              case 1:
              // Already on donations page
                break;
              case 2:
                _showAddItemDialog(context);
                break;
              case 3:
              // Chats - add your chat screen navigation here
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountScreen()),
                );
                break;
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