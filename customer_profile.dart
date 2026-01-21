import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile extends StatefulWidget {
  const CustomerProfile({super.key});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
 // final TextEditingController _experienceController = TextEditingController();
  String? _selectedGender;

  final List<String> _genders = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load saved data
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullNameController.text = prefs.getString('fullName') ?? '';
      _ageController.text = prefs.getString('age') ?? '';
      _selectedGender = prefs.getString('gender');
      _contactController.text = prefs.getString('contact') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
     // _experienceController.text = prefs.getString('experience') ?? '';
    });
  }

  // Save data
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', _fullNameController.text);
      await prefs.setString('age', _ageController.text);
      await prefs.setString('gender', _selectedGender ?? '');
      await prefs.setString('contact', _contactController.text);
      await prefs.setString('address', _addressController.text);
      await prefs.setString('email', _emailController.text);
     // await prefs.setString('experience', _experienceController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile saved successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back Arrow
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField("Full Name", "Enter your full name", _fullNameController),
                buildTextField("Age", "Enter your age", _ageController, keyboardType: TextInputType.number),

                Text("Gender", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: _genders.map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) => value == null ? "Please select a gender" : null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffececf8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 20),

                buildTextField("Contact Number", "Enter your contact number", _contactController, keyboardType: TextInputType.phone),
                buildTextField("Address", "Enter your address", _addressController),
                buildTextField("Email", "Enter your email", _emailController, keyboardType: TextInputType.emailAddress),
               // buildTextField("Experience", "Enter your experience", _experienceController),

                SizedBox(height: 20),
                Center(
                  child: OutlinedButton(
                    onPressed: _saveProfile,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      side: BorderSide(color: Colors.blueGrey), // Border color
                      backgroundColor: Colors.white, // Background color
                    ),
                    child: Text("Save", style: TextStyle(fontSize: 20, color: Colors.blueGrey)), // Text color
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffececf8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              hintText: hint,
            ),
            validator: (value) => value == null || value.isEmpty ? "This field cannot be empty" : null,
          ),
        ],
      ),
    );
  }
}
