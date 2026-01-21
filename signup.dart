import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanapp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedRole = 'Customer'; // Default role selection

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String uid = userCredential.user!.uid; // Get the generated UID

        // Add user details to Firestore with a custom 'Id' field
        await _firestore.collection('user').doc(uid).set({
          'Id': uid, // Store the same Firebase UID as 'Id'
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text, // ⚠ Storing passwords like this is not secure
          'role': _selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Store user data locally
        _storeUserData(_nameController.text, _emailController.text, _selectedRole);

        // Navigate to login screen
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogIn()));
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred";
        if (e.code == 'email-already-in-use') {
          message = "This email is already in use";
        } else if (e.code == 'weak-password') {
          message = "The password is too weak";
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> _storeUserData(String name, String email, String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('role', role);
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
                      "Sign up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    _buildTextField("Name", _nameController, Icons.person, "Enter Name"),
                    _buildTextField("Email", _emailController, Icons.email, "Enter Email"),
                    _buildTextField("Password", _passwordController, Icons.lock, "Enter Password", obscure: true),
                    _buildTextField("Confirm Password", _confirmPasswordController, Icons.lock, "Confirm Password", obscure: true),

                    // Role Selection Dropdown
                    Text(
                      "Select Role",
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: ['Customer', 'Cleaner'].map((role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 30.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _signUp,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                          },
                          child: Text(
                            "Log In",
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
            if (value == null || value.isEmpty) {
              return "$label cannot be empty";
            }
            if (label == "Confirm Password" && value != _passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}
