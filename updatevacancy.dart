import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateVacancy extends StatefulWidget {
  const UpdateVacancy({Key? key}) : super(key: key);

  @override
  _UpdateVacancyState createState() => _UpdateVacancyState();
}

class _UpdateVacancyState extends State<UpdateVacancy> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to delete a vacancy
  Future<void> _deleteVacancy(String docId) async {
    await _firestore.collection("Vacancy").doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vacancy deleted successfully")),
    );
  }

  // Function to update a vacancy
  Future<void> _updateVacancy(String docId, String currentOwner, String currentLocation, String currentPayment, String currentDescription) async {
    TextEditingController ownerController = TextEditingController(text: currentOwner);
    TextEditingController locationController = TextEditingController(text: currentLocation);
    TextEditingController paymentController = TextEditingController(text: currentPayment);
    TextEditingController descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Vacancy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Owner Name", ownerController),
              _buildTextField("Location", locationController),
              _buildTextField("Per Hour Payment", paymentController),
              _buildTextField("Description", descriptionController, maxLines: 3),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestore.collection("Vacancy").doc(docId).update({
                  "Owner Name": ownerController.text,
                  "Location": locationController.text,
                  "Per Hour Payment": paymentController.text,
                  "Description": descriptionController.text,
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Vacancy updated successfully")),
                );
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // UI for text fields
  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Update Vacancies", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection("Vacancy").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No vacancies available"));
            }

            var vacancies = snapshot.data!.docs;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allows horizontal scrolling
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Makes table responsive
                child: DataTable(
                  columnSpacing: 20, // Adjust column spacing
                  columns: [
                    DataColumn(label: Expanded(child: Text("Owner Name", style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text("Location", style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: vacancies.map((vacancy) {
                    var vacancyData = vacancy.data() as Map<String, dynamic>;

                    return DataRow(cells: [
                      DataCell(Container(
                          width: 100, // Adjust cell width
                          child: Text(vacancyData["Owner Name"] ?? "N/A", overflow: TextOverflow.ellipsis))),
                      DataCell(Container(
                          width: 100,
                          child: Text(vacancyData["Location"] ?? "N/A", overflow: TextOverflow.ellipsis))),
                      DataCell(Container(
                          width: 80,
                          child: Text(vacancyData["Per Hour Payment"] ?? "N/A", overflow: TextOverflow.ellipsis))),
                      DataCell(Container(
                          width: 150, // Wider for descriptions
                          child: Text(vacancyData["Description"] ?? "N/A", overflow: TextOverflow.ellipsis, maxLines: 2))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _updateVacancy(
                                vacancy.id,
                                vacancyData["Owner Name"],
                                vacancyData["Location"],
                                vacancyData["Per Hour Payment"],
                                vacancyData["Description"],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteVacancy(vacancy.id),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
