import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:firebase_auth/firebase_auth.dart';
import 'DonorVerificationScreen.dart';
import 'LoginScreen.dart';
import 'ProfileInformationScreen.dart';
import 'SavedItemsScreen.dart';
import 'HomePage.dart';
// import 'RegisterNewUser.dart';
import 'DonationItems.dart';
// import 'HomePage.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  // Mock user data
  Map<String, String> userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8901',
    'address': '123 Main St, City, Country',
    'role': 'Donor',
  };

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

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
          "My Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              children: [
                // User Profile Card
                _buildProfileCard(size, isSmallScreen),
                const SizedBox(height: 24),

                // Account Options
                _buildAccountOption(
                  icon: Icons.favorite,
                  title: "Saved Items",
                  subtitle: "View your favorite donations",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedItemsScreen(),
                      ),
                    );
                  },
                ),
                _buildAccountOption(
                  icon: Icons.person,
                  title: "Profile Information",
                  subtitle: "Update your personal details",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileInformationScreen(
                          userData: userData,
                          onSave: (updatedData) {
                            setState(() {
                              userData = updatedData;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                _buildAccountOption(
                  icon: Icons.verified_user,
                  title: "Verify Recipient",
                  subtitle: "Get verified to receive donations",
                  onTap: () {
                    // Navigate to verification
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DonorVerificationScreen()),
                    );
                  },
                ),
                _buildAccountOption(
                  icon: Icons.star,
                  title: "Reviews & Ratings",
                  subtitle: "See your donation history",
                  onTap: () {
                    // Navigate to reviews
                  },
                ),
                const SizedBox(height: 24),

                // Logout Button

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                     onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, 4), // Account is selected
    );
  }

  Widget _buildProfileCard(Size size, bool isSmallScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple.shade100,
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['name']!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData['email']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      userData['role']!,
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.deepPurple),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.deepPurple.shade300,
        ),
      ),
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
            } else if (index == 2) { // Add button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DonationItems()), // Or your "Add Item" screen
              );
            } else if (index == 4) {
              // Already on account screen
              return;
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