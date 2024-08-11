import 'package:flutter/material.dart';
import 'package:ecom/componets/products.dart'; // Adjust path as needed
import 'package:ecom/pages/product_details.dart'; // Adjust path as needed

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch product list from Product class
    List<Map<String, dynamic>> productList = Product.getProductList();

    // Filter products based on category
    List<Map<String, dynamic>> filteredProducts = productList
        .where((product) => product['category'] == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Products'),
        backgroundColor: Colors.red,
      ),
      body: filteredProducts.isEmpty
          ? Center(child: Text('No products found in this category.'))
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: filteredProducts.length,
        itemBuilder: (BuildContext context, int index) {
          var product = filteredProducts[index];
          return ProductCard(
            productName: product['name'],
            productPicture: product['picture'],
            productOldPrice: product['old_price'].toInt(),
            productNewPrice: product['price'].toInt(),
            productDetails: product['details'],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    product_detail_name: product['name'],
                    product_detail_new_price: product['price'],
                    product_detail_old_price: product['old_price'],
                    product_detail_picture: product['picture'],
                    product_detail_detail: product['details'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String productPicture;
  final int productOldPrice;
  final int productNewPrice;
  final String productDetails;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.productName,
    required this.productPicture,
    required this.productOldPrice,
    required this.productNewPrice,
    required this.productDetails,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                productPicture,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "\£$productNewPrice",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      "\£$productOldPrice",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      productDetails,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
