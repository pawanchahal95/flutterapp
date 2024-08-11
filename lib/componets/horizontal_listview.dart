import 'package:flutter/material.dart';
import 'package:ecom/pages/categories.dart'; // Import the CategoryProductsPage

class HorizontalList extends StatelessWidget {
  final bool isDarkMode; // Added parameter

  const HorizontalList({super.key, required this.isDarkMode}); // Required constructor parameter

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      color: isDarkMode ? Colors.black : Colors.white, // Background color based on theme
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Category(
            image_location: 'assets/images/tshirt.png',
            image_caption: 'Shirt',
            isDarkMode: isDarkMode, // Pass dark mode setting
          ),
          Category(
            image_location: 'assets/images/dress.png',
            image_caption: 'Dress',
            isDarkMode: isDarkMode, // Pass dark mode setting
          ),
          Category(
            image_location: 'assets/images/jeans.png',
            image_caption: 'Pants',
            isDarkMode: isDarkMode, // Pass dark mode setting
          ),
          Category(
            image_location: 'assets/images/formal.png',
            image_caption: 'Formal',
            isDarkMode: isDarkMode, // Pass dark mode setting
          ),
          Category(
            image_location: 'assets/images/accessories.png',
            image_caption: 'Accessories',
            isDarkMode: isDarkMode, // Pass dark mode setting
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String image_location;
  final String image_caption;
  final bool isDarkMode; // Added parameter

  Category({
    required this.image_location,
    required this.image_caption,
    required this.isDarkMode, // Required constructor parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          // Debugging output
          print('Category tapped: $image_caption');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(category: image_caption),
            ),
          );
        },
        child: Container(
          width: 120.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image_location,
                width: 80.0,
                height: 80.0,
              ),
              SizedBox(height: 5.0),
              Text(
                image_caption,
                style: TextStyle(
                  fontSize: 18.0,
                  color: isDarkMode ? Colors.white : Colors.black, // Text color based on theme
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
