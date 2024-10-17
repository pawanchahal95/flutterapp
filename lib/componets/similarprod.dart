import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom/pages/product_details.dart';

class SimilarProducts extends StatelessWidget {
  final String currentProduct;

  const SimilarProducts({Key? key, required this.currentProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('products').doc(currentProduct).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No similar products found.'));
        }

        final currentProductData = snapshot.data!.data() as Map<String, dynamic>;
        final currentCategory = currentProductData['category'];

        return FutureBuilder<QuerySnapshot>(
          future: _firestore
              .collection('products')
              .where('category', isEqualTo: currentCategory)
              .limit(4)
              .get(),
          builder: (context, similarSnapshot) {
            if (similarSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (similarSnapshot.hasError) {
              return Center(child: Text('Error: ${similarSnapshot.error}'));
            }
            if (!similarSnapshot.hasData || similarSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No similar products found.'));
            }

            final products = similarSnapshot.data!.docs;

            return SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index].data() as Map<String, dynamic>;
                  final name = product['name'];
                  final price = product['new_price'].toDouble(); // Ensure double
                  final picture = product['picture'];
                  final details = product['details'];
                  final oldPrice = product['old_price'].toDouble(); // Ensure double

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            product_detail_name: name,
                            product_detail_new_price: price.toInt(), // Ensure int
                            product_detail_old_price: oldPrice.toInt(), // Ensure int
                            product_detail_picture: picture,
                            product_detail_detail: details,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Image.asset(
                              picture,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Text(name, overflow: TextOverflow.ellipsis),
                          Text('\₹${price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
