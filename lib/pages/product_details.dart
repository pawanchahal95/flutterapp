import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'cart.dart';
import 'package:ecom/componets/similarprod.dart';
import 'favourite.dart';

class ProductDetails extends StatefulWidget {
  final String product_detail_name;
  final int product_detail_new_price;
  final int product_detail_old_price;
  final String product_detail_picture;
  final String product_detail_detail;

  ProductDetails({
    required this.product_detail_name,
    required this.product_detail_new_price,
    required this.product_detail_old_price,
    required this.product_detail_picture,
    required this.product_detail_detail,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? selectedSize;
  String? selectedColor;
  int selectedQuantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> addToCart() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .add({
        'name': widget.product_detail_name,
        'new_price': widget.product_detail_new_price.toDouble(), // Ensure double
        'old_price': widget.product_detail_old_price.toDouble(), // Ensure double
        'picture': widget.product_detail_picture,
        'details': widget.product_detail_detail,
        'size': selectedSize,
        'color': selectedColor,
        'quantity': selectedQuantity,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in')),
      );
    }
  }

  Future<void> toggleFavorite() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentReference docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.product_detail_name);

      if (isFavorite) {
        await docRef.delete();
        setState(() {
          isFavorite = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        await docRef.set({
          'name': widget.product_detail_name,
          'new_price': widget.product_detail_new_price.toDouble(), // Ensure double
          'old_price': widget.product_detail_old_price.toDouble(), // Ensure double
          'picture': widget.product_detail_picture,
          'details': widget.product_detail_detail,
        });
        setState(() {
          isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in')),
      );
    }
  }

  Future<void> checkIfFavorite() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .doc(widget.product_detail_name)
          .get();

      setState(() {
        isFavorite = docSnapshot.exists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text(
              'Fashapp',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? Color(0xFF8B0000) : Colors.red, // Dark red in dark mode
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cart()));
            },
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Black background in dark mode
      body: ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: isDarkMode ? Colors.black : Colors.grey[200], // Image container background
                child: Image.asset(widget.product_detail_picture),
              ),
              footer: Container(
                color: isDarkMode ? Colors.black54 : Colors.grey[300], // Footer background
                child: ListTile(
                  leading: Text(
                    widget.product_detail_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black, // Text color in dark mode
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "\£${widget.product_detail_old_price}",
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black54,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\£${widget.product_detail_new_price}",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          title: Text('Size', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile<String>(
                                title: Text('Small', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Small',
                                groupValue: selectedSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSize = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Medium', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Medium',
                                groupValue: selectedSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSize = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Large', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Large',
                                groupValue: selectedSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSize = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  textColor: isDarkMode ? Colors.white : Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Size: ${selectedSize ?? 'Select'}")),
                      Expanded(child: Icon(Icons.arrow_drop_down, color: isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          title: Text('Color', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile<String>(
                                title: Text('Red', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Red',
                                groupValue: selectedColor,
                                onChanged: (value) {
                                  setState(() {
                                    selectedColor = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Blue', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Blue',
                                groupValue: selectedColor,
                                onChanged: (value) {
                                  setState(() {
                                    selectedColor = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text('Green', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 'Green',
                                groupValue: selectedColor,
                                onChanged: (value) {
                                  setState(() {
                                    selectedColor = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  textColor: isDarkMode ? Colors.white : Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Color: ${selectedColor ?? 'Select'}")),
                      Expanded(child: Icon(Icons.arrow_drop_down, color: isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: isDarkMode ? Colors.black : Colors.white,
                          title: Text('Quantity', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RadioListTile<int>(
                                title: Text('1', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 1,
                                groupValue: selectedQuantity,
                                onChanged: (value) {
                                  setState(() {
                                    selectedQuantity = value!;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<int>(
                                title: Text('2', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 2,
                                groupValue: selectedQuantity,
                                onChanged: (value) {
                                  setState(() {
                                    selectedQuantity = value!;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              RadioListTile<int>(
                                title: Text('3', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                value: 3,
                                groupValue: selectedQuantity,
                                onChanged: (value) {
                                  setState(() {
                                    selectedQuantity = value!;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  textColor: isDarkMode ? Colors.white : Colors.black,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Qty: $selectedQuantity")),
                      Expanded(child: Icon(Icons.arrow_drop_down, color: isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    onPressed: addToCart,
                    color: isDarkMode ? Colors.red[900] : Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: Text('Add to Cart'),
                  ),
                ),
                IconButton(
                  onPressed: toggleFavorite,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          ListTile(
            title: Text("Product Details", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            subtitle: Text(widget.product_detail_detail, style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54)),
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  "Product name",
                  style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(widget.product_detail_name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: Text(
                  "Product price",
                  style: TextStyle(color: isDarkMode ? Colors.grey : Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("\£${widget.product_detail_new_price}", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimilarProducts(currentProduct: widget.product_detail_name),
          ),
        ],
      ),
    );
  }
}
