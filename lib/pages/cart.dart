import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_details.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<CartItem>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<List<CartItem>> _fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final cartSnapshot = await _firestore.collection('users').doc(userId).collection('cart').get();
    return cartSnapshot.docs.map((doc) => CartItem.fromFirestore(doc)).toList();
  }

  void _updateQuantity(CartItem item, int delta) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final newQuantity = item.quantity + delta;
    if (newQuantity < 1) return;

    _firestore.collection('users').doc(userId).collection('cart').doc(item.id).update({
      'quantity': newQuantity,
    }).then((_) {
      setState(() {
        _cartItemsFuture = _fetchCartItems();
      });
    });
  }

  void _deleteItem(CartItem item) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _firestore.collection('users').doc(userId).collection('cart').doc(item.id).delete().then((_) {
      setState(() {
        _cartItemsFuture = _fetchCartItems();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
            },
            icon: Icon(Icons.shopping_cart, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!;
          final total = cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product_detail_name: item.name,
                        product_detail_new_price: item.price.toInt(),
                        product_detail_old_price: item.oldPrice.toInt(),
                        product_detail_picture: item.picture,
                        product_detail_detail: item.details,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 140,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 3))],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.all(8),
                        child: Image.asset(
                          item.picture,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('\$${item.price.toStringAsFixed(2)}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove, color: Colors.red),
                                  onPressed: () => _updateQuantity(item, -1),
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: Icon(Icons.add, color: Colors.red),
                                  onPressed: () => _updateQuantity(item, 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.white70,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text("Total:"),
                subtitle: FutureBuilder<List<CartItem>>(
                  future: _cartItemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("\$0.00");
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Text("\$0.00");
                    }
                    final total = snapshot.data!.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));
                    return Text("\$${total.toStringAsFixed(2)}");
                  },
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  // Implement checkout logic
                },
                child: Text("Check out", style: TextStyle(color: Colors.white70)),
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final int quantity;
  final String picture;
  final String details;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.quantity,
    required this.picture,
    required this.details,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      name: data['name'],
      price: (data['new_price'] as num).toDouble(),
      oldPrice: (data['old_price'] as num).toDouble(),
      quantity: data['quantity'] as int,
      picture: data['picture'],
      details: data['details'],
    );
  }
}
