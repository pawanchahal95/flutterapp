import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ecom/pages/home.dart'; // Replace with your actual HomePage import

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  bool _obscureText = true; // To manage password visibility
  bool _obscureConfirmText = true; // To manage confirm password visibility
  String _userType = 'Buyer'; // Default user type

  Future<void> _handleAuth() async {
    setState(() {
      _loading = true;
    });

    try {
      if (_isLogin) {
        // Login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _handleUserData(userCredential.user);
      } else {
        // Sign Up
        if (_passwordController.text != _confirmPasswordController.text) {
          Fluttertoast.showToast(msg: "Passwords do not match.");
          return;
        }
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _handleUserData(userCredential.user, true); // Pass true for signup
        Fluttertoast.showToast(msg: "Signup successful");
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'weak-password':
          errorMsg = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMsg = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMsg = 'The email address is badly formatted.';
          break;
        case 'user-not-found':
          errorMsg = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMsg = 'Wrong password provided for that user.';
          break;
        default:
          errorMsg = e.message ?? 'An internal error occurred.';
      }
      Fluttertoast.showToast(msg: errorMsg);
      print('Error during authentication: $errorMsg');
    } catch (e) {
      Fluttertoast.showToast(msg: 'An unexpected error occurred: $e');
      print('Unexpected error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleUserData(User? user, [bool isSignup = false]) async {
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (isSignup || !userDoc.exists) {
        // Only set the username and user type during signup
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'username': _usernameController.text,
          'email': user.email,
          'profilePicture': user.photoURL,
          'userType': _userType, // Include user type
        });
      } else {
        // Update preferences with existing user data
        await prefs.setString("username", userDoc['username']);
      }

      await prefs.setString("id", user.uid);
      await prefs.setString("email", user.email ?? '');

      Fluttertoast.showToast(msg: "Login successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Replace with your actual HomePage widget
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
        backgroundColor: Colors.red, // Red color for the app bar
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/fashion1.png',
                  fit: BoxFit.cover, // Ensure the image covers the entire area
                ),
              ),
              // Content
              SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/fashion2.png', // Image path
                          height: 150, // Adjust height as needed
                        ),
                      ),
                      SizedBox(height: 20),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6), // Updated opacity
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person), // Person icon added here
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.6), // Updated opacity
                            ),
                          ),
                        ),
                      if (!_isLogin) SizedBox(height: 16.0),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6), // Updated opacity
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'I am a:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text('Buyer'),
                                      leading: Radio<String>(
                                        value: 'Buyer',
                                        groupValue: _userType,
                                        onChanged: (value) {
                                          setState(() {
                                            _userType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text('Seller'),
                                      leading: Radio<String>(
                                        value: 'Seller',
                                        groupValue: _userType,
                                        onChanged: (value) {
                                          setState(() {
                                            _userType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6), // Updated opacity
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.6), // Updated opacity
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6), // Updated opacity
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.6), // Updated opacity
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6), // Updated opacity
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmText,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmText = !_obscureConfirmText;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.6), // Updated opacity
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loading ? null : _handleAuth,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Red background color
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _loading
                            ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(color: Colors.white), // White text color
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                            style: TextStyle(color: Colors.black), // Black text color
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? 'Sign Up' : 'Login',
                              style: TextStyle(
                                color: Colors.red, // Red text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
