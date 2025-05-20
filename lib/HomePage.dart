import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ListedItem.dart';
import 'AccountScreen.dart';
import 'ItemDetailsScreen.dart';
import 'ListedItem.dart';
import 'Notifications.dart';
import 'AddItemScreen.dart';
import 'DonationItems.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('items');

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
                  onPressed: () => Navigator.pop(context),
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
                    Navigator.pop(context);
                    if (sellChecked || donateChecked || exchangeChecked) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemScreen(
                            itemType: sellChecked
                                ? "Sell"
                                : donateChecked
                                ? "Donate"
                                : "Exchange",
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

  Widget _buildFeaturedItemsGrid(bool isLargeScreen) {
    return StreamBuilder(
      stream: _databaseRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final itemsMap = snapshot.data?.snapshot.value as Map<dynamic, dynamic>?;
        if (itemsMap == null || itemsMap.isEmpty) {
          return const Center(child: Text('No items available'));
        }

        final items = itemsMap.entries.map((entry) {
          final data = entry.value as Map<dynamic, dynamic>;
          return ItemModel.fromMap(Map<String, dynamic>.from(data));
        }).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLargeScreen ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(
                      item: {
                        "image": item.image,
                        "title": item.productName,
                        "price": item.productPrice,
                        "description": item.productDescription,
                        "donor": {
                          "name": "Donor Name", // Add actual donor data
                          "address": "Donor Address",
                          "cnic": "Donor CNIC"
                        }
                      },
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
                        child: item.image.isNotEmpty
                            ? Image.memory(
                          base64Decode(item.image),
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                            : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Rs. ${item.productPrice}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border,
                                    size: 20, color: Colors.grey.shade600),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      body: SafeArea(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isLargeScreen ? 24 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isLargeScreen),
                  const SizedBox(height: 24),
                  _buildSearchBar(isLargeScreen),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Featured Items",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ItemListed()),
                        ),
                        child: Text(
                          "See all",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturedItemsGrid(isLargeScreen),
                  const SizedBox(height: 32),
                  _buildSectionHeader("Browse by Category", "See all"),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) =>
                          _buildCategoryItem(_categories[index], context),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Rest of the helper widgets remain the same as previous version
  // (_buildHeader, _buildSearchBar, _buildSectionHeader,
  // _buildCategoryItem, _buildBottomNavBar)

  // Add your category list
  final List<Map<String, dynamic>> _categories = [
    {"icon": Icons.electrical_services, "title": "Electronics"},
    {"icon": Icons.watch_outlined, "title": "Watches"},
    {"icon": Icons.chair_alt_outlined, "title": "Furniture"},
    {"icon": Icons.menu_book, "title": "Books"},
    {"icon": Icons.kitchen, "title": "Kitchenware"},
    {"icon": Icons.toys, "title": "Toys"},
  ];

  Widget _buildHeader(BuildContext context, bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 8 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome, Share Mart!",
                style: TextStyle(
                  fontSize: isLargeScreen ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Find items to donate or request",
                style: TextStyle(
                  fontSize: isLargeScreen ? 16 : 14,
                  color: Colors.deepPurple.shade600,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notifications()),
            ),
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications, color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for items...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(
            actionText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepPurple.shade400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category, BuildContext context) {
    return GestureDetector(
      onTap: () {/* Handle category tap */},
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(category["icon"], size: 28, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              category["title"],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
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
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey.shade500,
          backgroundColor: Colors.white,
          showUnselectedLabels: true,
          elevation: 10,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonationItems()),
              );
            } else if (index == 2) {
              _showAddItemDialog(context);
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

class ItemModel {
  final String productName;
  final String productPrice;
  final String productDescription;
  final String image;
  final String sellerId;
  final String sellerName;
  final String itemId;
  final String itemType;

  ItemModel({
    required this.productName,
    required this.productPrice,
    required this.productDescription,
    required this.image,
    required this.sellerId,
    required this.sellerName,
    required this.itemId,
    required this.itemType,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      productName: map['productName'] ?? '',
      productPrice: map['productPrice'] ?? '',
      productDescription: map['productDescription'] ?? '',
      image: map['image'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      itemId: map['itemId'] ?? '',
      itemType: map['itemType'] ?? 'sell',
    );
  }
}