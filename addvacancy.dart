import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddVacancy extends StatefulWidget {
  const AddVacancy({Key? key}) : super(key: key);

  @override
  _AddVacancyState createState() => _AddVacancyState();
}

class _AddVacancyState extends State<AddVacancy> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedCategory;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addVacancy() async {
    User? user = _auth.currentUser; // Get the logged-in user

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: No user logged in!")),
      );
      return;
    }

    if (selectedCategory != null &&
        _ownerNameController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _paymentController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      try {
        // Generate a unique Vacancy ID
        String vacancyId = _firestore.collection("Vacancy").doc().id;

        await _firestore.collection("Vacancy").doc(vacancyId).set({
          'Id': vacancyId,
          'Category': selectedCategory,
          'Owner Name': _ownerNameController.text,
          'Location': _locationController.text,
          'Per Hour Payment': _paymentController.text,
          'Description': _descriptionController.text,
          'Customer Id': user.uid, // Store the logged-in user's ID as customerId
          'timestamp': FieldValue.serverTimestamp(),
        });


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vacancy added successfully!")),
        );

        setState(() {
          _ownerNameController.clear();
          _locationController.clear();
          _paymentController.clear();
          _descriptionController.clear();
          selectedCategory = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add New Vacancy',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Enter Owner Name", _ownerNameController),
                _buildTextField("Location", _locationController),
                _buildDropdown(),
                _buildTextField("Per Hour Payment", _paymentController),
                _buildTextField("Description about vacancy", _descriptionController, maxLines: 4),
                const SizedBox(height: 50),
                Center(
                  child: OutlinedButton(
                    onPressed: _addVacancy,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blueGrey),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Category', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            value: selectedCategory,
            hint: Text('Select Category'),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
            items: ['Repair', 'Clean', 'Laundry', 'Paint']
                .map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
