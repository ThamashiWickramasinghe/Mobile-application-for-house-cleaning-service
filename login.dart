
import 'package:cleanapp/pages/bottom_nav.dart';
import 'package:cleanapp/pages/customerbottom.dart';
import 'package:cleanapp/pages/home.dart';
import 'package:cleanapp/pages/profile.dart';
import 'package:cleanapp/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false; // Loading indicator

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Perform login action using Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        // Fetch user role from Firestore
        DocumentSnapshot userDoc = await _firestore.collection('user').doc(uid).get();

        if (!userDoc.exists) {
          throw FirebaseAuthException(code: 'user-not-found', message: "User data not found in Firestore.");
        }

        String role = userDoc['role'];

        // Redirect user based on role
        if (role == 'Customer') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerBottom()));
        } else if (role == 'Cleaner') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invalid role assigned. Contact support.'),
            backgroundColor: Colors.red,
          ));
        }
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred";
        if (e.code == 'user-not-found') {
          message = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          message = "Incorrect password.";
        } else if (e.code == 'invalid-email') {
          message = "The email address is badly formatted.";
        } else {
          message = e.message ?? 'An unknown error occurred';
        }

        // Display the error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/register.jpg"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome!",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 33.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 90.0),
                    _buildTextField("Email", _emailController, Icons.email, "Enter Email"),
                    SizedBox(height: 40.0),
                    _buildTextField("Password", _passwordController, Icons.password, "Enter Password", obscure: true),

                    SizedBox(height: 20),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(color: Colors.blueGrey, width: 2),
                          ),
                        ),
                        onPressed: _login,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have An Account? ", style: TextStyle(fontSize: 18.0)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.blueGrey, fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String hintText, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            suffixIcon: Icon(icon, color: Colors.grey),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label cannot be empty";
            }
            return null;
          },
        ),
      ],
    );
  }
}
