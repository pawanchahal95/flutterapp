import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:ecom/componets/horizontal_listview.dart';
import 'package:ecom/componets/products.dart'; // Ensure this import is correct
import 'package:ecom/pages/cart.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore
import 'package:ecom/pages/login.dart';
import 'package:ecom/pages/favourite.dart';
import 'package:ecom/pages/setting.dart'; // Import Settings page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> _userData;
  bool _isDarkMode = false; // Track the theme mode

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Navigate to Login page
      );
    } catch (e) {
      // Handle any errors that occur during logout
      print('Error during logout: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return doc.data() as Map<String, dynamic>;
    }
    return {};
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    Widget imagecarousel = Container(
      height: 250.0,
      child: AnotherCarousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/1.png'),
          AssetImage('assets/images/2.png'),
          AssetImage('assets/images/3.png'),
          AssetImage('assets/images/4.png'),
        ],
        autoplay: true,
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white, // Set background color
      appBar: AppBar(
        title: Text(
          'Fashapp',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black, // Text color based on theme
          ),
        ),
        centerTitle: false,
        backgroundColor: _isDarkMode ? Color(0xFF8B0000) : Colors.red, // Conditional background color
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: _isDarkMode ? Colors.white : Colors.black, // Icon color based on theme
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: _isDarkMode ? Colors.white : Colors.black, // Icon color based on theme
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: _isDarkMode ? Colors.grey[900] : Colors.white, // Dark background for drawer
          child: Column(
            children: <Widget>[
              FutureBuilder<Map<String, dynamic>>(
                future: _fetchUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return UserAccountsDrawerHeader(
                      accountName: Text('Loading...', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      accountEmail: Text('', style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54)),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person_3, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Color(0xFF8B0000) : Colors.red, // Dark red color for drawer header in dark mode
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return UserAccountsDrawerHeader(
                      accountName: Text('No Name', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      accountEmail: Text('Not logged in', style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54)),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person_3, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Color(0xFF8B0000) : Colors.red, // Dark red color for drawer header in dark mode
                      ),
                    );
                  }

                  var userData = snapshot.data!;
                  return UserAccountsDrawerHeader(
                    accountName: Text(userData['username'] ?? 'No Name', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                    accountEmail: Text(userData['email'] ?? 'Not logged in', style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54)),
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        // Add action if needed
                      },
                      child: CircleAvatar(
                        backgroundImage: userData['profilePicture'] != null
                            ? NetworkImage(userData['profilePicture'])
                            : AssetImage('assets/images/default_user.png') as ImageProvider,
                        backgroundColor: Colors.grey,
                        child: userData['profilePicture'] == null
                            ? Icon(Icons.person_3, color: Colors.white)
                            : null,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Color(0xFF8B0000) : Colors.red, // Dark red color for drawer header in dark mode
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.home, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text("Home Page", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person_2, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text("My Account", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_basket, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text("My Orders", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text("Shopping Cart", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cart()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite, color: _isDarkMode ? Colors.white : Colors.black),
                      title: Text("Favourites", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteProductsPage(isDarkMode: _isDarkMode),
                          ),
                        );
                      },
                    ),
                    Divider(color: _isDarkMode ? Colors.white30 : Colors.black12),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.lightBlueAccent),
                      title: Text("Settings", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              onThemeChanged: _toggleTheme,
                              currentTheme: _isDarkMode,
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help, color: Colors.greenAccent),
                      title: Text("About", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                      },
                    ),
                    Divider(color: _isDarkMode ? Colors.white30 : Colors.black12),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text("Logout", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                      onTap: _logout, // Logout function
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          imagecarousel,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          HorizontalList(isDarkMode: _isDarkMode), // Pass dark mode setting
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'New Arrivals',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            height: 320.0,
            color: _isDarkMode ? Colors.black : Colors.white70,
            child: Product(),
          ),
        ],
      ),
    );
  }
}
