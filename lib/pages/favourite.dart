import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_details.dart';

class FavoriteProductsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final bool isDarkMode; // Track the theme mode

  FavoriteProductsPage({required this.isDarkMode});

  Stream<QuerySnapshot> getFavoriteProducts() {
    User? user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .snapshots();
    } else {
      return Stream.empty();
    }
  }

  Future<void> removeFromFavorites(BuildContext context, String productName) async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(productName)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Products'),
        backgroundColor: Colors.red, // Keep AppBar color constant
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getFavoriteProducts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final favoriteProducts = snapshot.data!.docs;

          if (favoriteProducts.isEmpty) {
            return Center(child: Text('No favorite products found.'));
          }

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              var product = favoriteProducts[index];
              return FavoriteProductItem(
                productName: product['name'],
                productNewPrice: product['new_price'].toInt(),
                productOldPrice: product['old_price'].toInt(),
                productPicture: product['picture'],
                productDetail: product['details'],
                onRemoveFromFavorites: () => removeFromFavorites(context, product['name']),
                isDarkMode: isDarkMode,
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteProductItem extends StatelessWidget {
  final String productName;
  final int productNewPrice;
  final int productOldPrice;
  final String productPicture;
  final String productDetail;
  final VoidCallback onRemoveFromFavorites;
  final bool isDarkMode;

  FavoriteProductItem({
    required this.productName,
    required this.productNewPrice,
    required this.productOldPrice,
    required this.productPicture,
    required this.productDetail,
    required this.onRemoveFromFavorites,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(productPicture, fit: BoxFit.cover, height: 200.0),
            SizedBox(height: 8.0),
            Text(
              productName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              "\$$productNewPrice",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
              ),
            ),
            Text(
              "\$$productOldPrice",
              style: TextStyle(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              productDetail,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          product_detail_name: productName,
                          product_detail_new_price: productNewPrice,
                          product_detail_old_price: productOldPrice,
                          product_detail_picture: productPicture,
                          product_detail_detail: productDetail,
                        ),
                      ),
                    );
                  },
                  child: Text('View Details'),
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: onRemoveFromFavorites,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
