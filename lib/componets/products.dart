
  import 'package:flutter/material.dart';
  import 'package:ecom/pages/product_details.dart';

  class Product extends StatefulWidget {
    @override
    _ProductState createState() => _ProductState();

    static List<Map<String, dynamic>> getProductList() {
      return _ProductState.product_list; // Access the list from the state
    }
  }

  class _ProductState extends State<Product> {
   static List<Map<String, dynamic>> product_list = [
  // Your product list
    {
      "name": "Casual Shirt",
      "picture": "assets/images/shirt1.png",
      "old_price": 60,
      "price": 40,
      "details": "A comfortable and stylish casual shirt made from breathable cotton. Features a modern fit with a classic button-down collar. Perfect for everyday wear or casual outings.",
      "brand_name": "Trendsetter Apparel",
      "likes": 75,
      "category": "Shirt"
    },
    {
      "name": "Plaid Button-Up",
      "picture": "assets/images/shirt2.png",
      "old_price": 70,
      "price": 50,
      "details": "A classic plaid button-up shirt with a relaxed fit. Made from soft cotton fabric, it offers both comfort and style for casual and semi-formal occasions.",
      "brand_name": "Heritage Threads",
      "likes": 85,
      "category": "Shirt"
    },
    {
      "name": "Slim Fit Oxford",
      "picture": "assets/images/shirt3.png",
      "old_price": 80,
      "price": 55,
      "details": "A tailored slim fit oxford shirt in a variety of colors. Features a button-down collar and durable fabric, making it suitable for both work and casual settings.",
      "brand_name": "City Fashion",
      "likes": 90,
      "category": "Shirt"
    },
    {
      "name": "Denim Shirt",
      "picture": "assets/images/shirt4.png",
      "old_price": 85,
      "price": 60,
      "details": "A versatile denim shirt with a relaxed fit. Made from high-quality denim, it’s perfect for layering or wearing on its own. Includes chest pockets for added style.",
      "brand_name": "Rugged Wear",
      "likes": 95,
      "category": "Shirt"
    },
    {
      "name": "Floral Print Shirt",
      "picture": "assets/images/shirt5.png",
      "old_price": 65,
      "price": 45,
      "details": "A vibrant floral print shirt that adds a touch of personality to any outfit. Made from lightweight fabric, it’s ideal for warm weather and casual outings.",
      "brand_name": "Summer Breeze",
      "likes": 100,
      "category": "Shirt"
    },
    {
      "name": "Striped Polo",
      "picture": "assets/images/shirt6.png",
      "old_price": 55,
      "price": 35,
      "details": "A classic striped polo shirt with a comfortable fit. Made from breathable cotton, it’s perfect for casual wear and comes in a range of colors.",
      "brand_name": "Sporty Look",
      "likes": 70,
      "category": "Shirt"
    },
    {
      "name": "Summer Dress",
      "picture": "assets/images/dress1.png",
      "old_price": 90,
      "price": 65,
      "details": "A vibrant summer dress designed for sunny days. Made from lightweight fabric with a flowy silhouette. Includes a flattering belt and adjustable straps for a perfect fit.",
      "brand_name": "Elegant Designs",
      "likes": 130,
      "category": "Dress"
    },
    {
      "name": "Evening Gown",
      "picture": "assets/images/dress2.png",
      "old_price": 200,
      "price": 150,
      "details": "A stunning evening gown made from luxurious satin. Features a fitted bodice, flowing skirt, and intricate beading. Ideal for formal events and special occasions.",
      "brand_name": "Glamour Couture",
      "likes": 90,
      "category": "Dress"
    },
    {
      "name": "Maxi Dress",
      "picture": "assets/images/dress3.png",
      "old_price": 110,
      "price": 80,
      "details": "A beautiful maxi dress with a bohemian vibe. Made from soft, breathable fabric with a floral print. Includes adjustable straps and a cinched waist for added comfort.",
      "brand_name": "Boho Chic",
      "likes": 120,
      "category": "Dress"
    },
    {
      "name": "Cocktail Dress",
      "picture": "assets/images/dress4.png",
      "old_price": 85,
      "price": 60,
      "details": "A stylish cocktail dress with a flattering A-line cut. Made from a blend of polyester and spandex for a comfortable fit. Perfect for parties and evening events.",
      "brand_name": "Nightlife Fashion",
      "likes": 75,
      "category": "Dress"
    },
    {
      "name": "Shift Dress",
      "picture": "assets/images/dress5.png",
      "old_price": 70,
      "price": 50,
      "details": "A chic shift dress with a simple, elegant design. Made from high-quality cotton blend fabric. Features a knee-length hem and classic cut for a timeless look.",
      "brand_name": "Urban Essentials",
      "likes": 85,
      "category": "Dress"
    },
    {
      "name": "Wrap Dress",
      "picture": "assets/images/dress6.png",
      "old_price": 75,
      "price": 55,
      "details": "A versatile wrap dress that can be styled in multiple ways. Made from lightweight fabric with a wrap-around tie. Ideal for both casual and semi-formal occasions.",
      "brand_name": "Timeless Trends",
      "likes": 95,
      "category": "Dress"
    },
    {
      "name": "Slim Fit Pants",
      "picture": "assets/images/pants1.png",
      "old_price": 80,
      "price": 55,
      "details": "These slim fit pants offer a tailored look with a comfortable stretch fabric. Ideal for both casual and semi-formal settings. Features a zip fly and side pockets for convenience.",
      "brand_name": "Urban Style",
      "likes": 90,
      "category": "Pants"
    },
    {
      "name": "Chinos",
      "picture": "assets/images/pants2.png",
      "old_price": 70,
      "price": 50,
      "details": "Classic chinos made from durable cotton fabric. Features a slim fit with a flat front and side pockets. Ideal for casual wear or a smart-casual look.",
      "brand_name": "Everyday Wear",
      "likes": 80,
      "category": "Pants"
    },
    {
      "name": "Cargo Pants",
      "picture": "assets/images/pants3.png",
      "old_price": 85,
      "price": 60,
      "details": "Utility cargo pants with multiple pockets and adjustable waistband. Made from sturdy fabric, these pants are perfect for outdoor activities and casual wear.",
      "brand_name": "Active Gear",
      "likes": 70,
      "category": "Pants"
    },
    {
      "name": "Dress Pants",
      "picture": "assets/images/pants4.png",
      "old_price": 90,
      "price": 65,
      "details": "Elegant dress pants made from a wool blend. Features a tailored fit with a flat front and sharp crease. Ideal for formal events and business meetings.",
      "brand_name": "Professional Attire",
      "likes": 85,
      "category": "Pants"
    },
    {
      "name": "Joggers",
      "picture": "assets/images/pants5.png",
      "old_price": 60,
      "price": 40,
      "details": "Comfortable joggers made from soft fleece fabric. Features an elastic waistband with adjustable drawstring and ribbed cuffs. Perfect for lounging or casual outings.",
      "brand_name": "Casual Comfort",
      "likes": 100,
      "category": "Pants"
    },
    {
      "name": "Wide Leg Pants",
      "picture": "assets/images/pants6.png",
      "old_price": 75,
      "price": 55,
      "details": "Stylish wide leg pants with a high waist. Made from lightweight fabric with a flowing silhouette. Ideal for both casual and dressy occasions.",
      "brand_name": "Fashion Forward",
      "likes": 90,
      "category": "Pants"
    },
    {
      "name": "Formal Suit",
      "picture": "assets/images/formal1.png",
      "old_price": 250,
      "price": 180,
      "details": "A sophisticated formal suit made from high-quality wool blend. Features a classic notch lapel, two-button closure, and a fully lined interior. Perfect for business meetings or formal events.",
      "brand_name": "Prestige Tailors",
      "likes": 80,
      "category": "Formal"
    },
    {
      "name": "Dress Shirt",
      "picture": "assets/images/formal2.png",
      "old_price": 70,
      "price": 50,
      "details": "A crisp dress shirt made from premium cotton. Features a spread collar and adjustable cuffs. Ideal for pairing with a suit or dress pants for a polished look.",
      "brand_name": "Refined Styles",
      "likes": 95,
      "category": "Formal"
    },
    {
      "name": "Tuxedo Jacket",
      "picture": "assets/images/formal3.png",
      "old_price": 150,
      "price": 120,
      "details": "A classic tuxedo jacket with a satin finish. Features a peak lapel and a single-breasted design. Perfect for black-tie events and formal occasions.",
      "brand_name": "Gala Attire",
      "likes": 85,
      "category": "Formal"
    },
    {
      "name": "Tailored Vest",
      "picture": "assets/images/formal4.png",
      "old_price": 100,
      "price": 75,
      "details": "A tailored vest that complements formal suits. Made from a high-quality wool blend with adjustable straps. Ideal for adding a touch of sophistication to your outfit.",
      "brand_name": "Formal Essentials",
      "likes": 70,
      "category": "Formal"
    },
    {
      "name": "Cufflinks Set",
      "picture": "assets/images/formal5.png",
      "old_price": 45,
      "price": 30,
      "details": "A set of elegant cufflinks designed to add a touch of class to any dress shirt. Made from polished stainless steel with a classic design.",
      "brand_name": "Elegant Touch",
      "likes": 60,
      "category": "Formal"
    },
    {
      "name": "Dress Shoes",
      "picture": "assets/images/formal6.png",
      "old_price": 120,
      "price": 90,
      "details": "High-quality dress shoes made from genuine leather. Features a sleek design with a polished finish. Ideal for formal events and business meetings.",
      "brand_name": "Luxury Footwear",
      "likes": 100,
      "category": "Formal"
    },
    {
      "name": "Leather Belt",
      "picture": "assets/images/accessory1.png",
      "old_price": 40,
      "price": 30,
      "details": "A premium leather belt with a sleek buckle design. Made from genuine leather, it offers durability and style. Suitable for both formal and casual wear.",
      "brand_name": "Luxury Accessories",
      "likes": 60,
      "category": "Accessories"
    },
    {
      "name": "Stylish Sunglasses",
      "picture": "assets/images/accessory2.png",
      "old_price": 50,
      "price": 35,
      "details": "Trendy sunglasses with UV protection lenses. Features a contemporary design with a durable frame. Ideal for sunny days and outdoor activities.",
      "brand_name": "Sunshine Gear",
      "likes": 140,
      "category": "Accessories"
    },
    {
      "name": "Wool Scarf",
      "picture": "assets/images/accessory3.png",
      "old_price": 55,
      "price": 40,
      "details": "A warm and cozy wool scarf perfect for chilly weather. Features a classic design with fringe edges. Made from high-quality wool for added comfort.",
      "brand_name": "Winter Wardrobe",
      "likes": 80,
      "category": "Accessories"
    },
    {
      "name": "Fashionable Hat",
      "picture": "assets/images/accessory4.png",
      "old_price": 35,
      "price": 25,
      "details": "A stylish hat designed to complete your look. Made from breathable fabric with a classic brim design. Ideal for casual and semi-formal occasions.",
      "brand_name": "Headwear Haven",
      "likes": 70,
      "category": "Accessories"
    },
    {
      "name": "Elegant Watch",
      "picture": "assets/images/accessory5.png",
      "old_price": 200,
      "price": 150,
      "details": "An elegant watch with a minimalist design. Features a stainless steel band and a classic analog face. Perfect for adding a touch of sophistication to any outfit.",
      "brand_name": "Timeless Elegance",
      "likes": 100,
      "category": "Accessories"
    },
    {
      "name": "Tote Bag",
      "picture": "assets/images/accessory6.png",
      "old_price": 70,
      "price": 50,
      "details": "A versatile tote bag made from durable canvas. Features spacious compartments and sturdy handles. Ideal for everyday use or casual outings.",
      "brand_name": "Bag Essentials",
      "likes": 90,
      "category": "Accessories"
    },


  ];

  @override
  Widget build(BuildContext context) {
  // Sort the product list by likes in descending order and take the top 6
  product_list.sort((a, b) => b['likes'].compareTo(a['likes']));
  var top_products = product_list.take(6).toList();

  return GridView.builder(
  itemCount: top_products.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  itemBuilder: (BuildContext context, int index) {
  return Single_prod(
  prod_name: top_products[index]['name'] as String,
  prod_picture: top_products[index]['picture'] as String,
  prod_old_price: top_products[index]['old_price'] as int,
  prod_price: top_products[index]['price'] as int,
  prod_details: top_products[index]['details'] as String,
  prod_brand_name: top_products[index]['brand_name'] as String,
  prod_likes: top_products[index]['likes'] as int,
  prod_category: top_products[index]['category'] as String,
  );
  },
  );
  }
  }

  class Single_prod extends StatelessWidget {
  final String prod_name;
  final String prod_picture;
  final int prod_old_price;
  final int prod_price;
  final String prod_details;
  final String prod_brand_name;
  final int prod_likes;
  final String prod_category;

  const Single_prod({
  super.key,
  required this.prod_name,
  required this.prod_picture,
  required this.prod_old_price,
  required this.prod_price,
  required this.prod_details,
  required this.prod_brand_name,
  required this.prod_likes,
  required this.prod_category,
  });

  @override
  Widget build(BuildContext context) {
  return Card(
  child: Hero(
  tag: prod_name, // Updated tag to use product name for Hero animation
  child: Material(
  child: InkWell(
  onTap: () => Navigator.of(context).push(
  MaterialPageRoute(
  builder: (context) => ProductDetails(
  product_detail_name: prod_name,
  product_detail_new_price: prod_price,
  product_detail_old_price: prod_old_price,
  product_detail_picture: prod_picture,
  product_detail_detail: prod_details,
  ),
  ),
  ),
  child: GridTile(
  footer: Container(
  color: Colors.white70,
  child: Row(
  children: <Widget>[
  Expanded(
  child: Text(
  prod_name,
  style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16.0,
  ),
  ),
  ),
  Text(
  "\$${prod_price}",
  style: TextStyle(
  color: Colors.red,
  fontWeight: FontWeight.bold,
  ),
  ),
  ],
  ),
  ),
  child: Image.asset(
  prod_picture,
  fit: BoxFit.cover,
  ),
  ),
  ),
  ),
  ),
  );
  }
  }
