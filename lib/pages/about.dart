import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About FashApp', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            // Title Section
            Center(
              child: Text(
                'Welcome to FashApp',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 20),

            // App Description Section
            Text(
              'FashApp is an innovative e-commerce platform designed to provide users with a seamless shopping experience. Whether you are a buyer or a seller, FashApp offers a wide range of features that cater to all your online shopping needs.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Key Features
            Text(
              'Key Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '• User-friendly interface for browsing products.\n'
                  '• Seamless sign-up and login with Firebase Authentication.\n'
                  '• Add products to your cart, adjust quantities, and check out.\n'
                  '• Save your favorite products with a heart icon.\n'
                  '• Seller and Buyer roles to help you manage your product listings.\n'
                  '• Responsive and attractive UI designed with Flutter.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Development Info Section
            Text(
              'Developed by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'This app is developed using Flutter by the team at ASD (Academy of Skill Development).\n'
                  'FashApp aims to revolutionize the e-commerce industry with its intuitive and easy-to-use interface, providing buyers and sellers with the tools they need to buy and sell products with ease.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Contact Information Section
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'For support or feedback, you can reach us at:\n'
                  'Website: http://www.asd.org.on/\n'
                  'Email: support@asd.org.on\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Disclaimer Section
            Text(
              'Disclaimer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'FashApp is an e-commerce platform built for educational purposes and is not responsible for any transactions made between buyers and sellers. Please review all transactions carefully before confirming.\n',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
