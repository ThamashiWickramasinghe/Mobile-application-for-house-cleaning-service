
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Clean extends StatefulWidget {
  const Clean({super.key});

  @override
  State<Clean> createState() => _CleanState();
}

class _CleanState extends State<Clean> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cleaning Services", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection("Vacancy")
              .where("Category", isEqualTo: "Clean") // Fetch only Clean category vacancies
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No cleaning vacancies available"));
            }

            var vacancies = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: vacancies.length,
              itemBuilder: (context, index) {
                var vacancyData = vacancies[index].data() as Map<String, dynamic>? ?? {};

                String ownerId = vacancies[index].id; // Ensure we pass the correct vacancy ID

                // Alternate background colors
                Color cardColor = index % 2 == 0 ? Color(0xffffd6e0) : Color(0xfffff4c3);

                return _buildCleaningCard(
                  cardColor,
                  vacancyData["Owner Name"] ?? "Unknown",
                  vacancyData["Location"] ?? "Not specified",
                  vacancyData["Per Hour Payment"]?.toString() ?? "Not specified",
                  vacancyData["Description"] ?? "No description provided",
                  ownerId, // Pass the owner ID to Book page
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCleaningCard(Color cardColor, String owner, String location, String payment, String description, String ownerId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade400, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.person, "Owner:", owner),
          _buildInfoRow(Icons.location_on, "Location:", location),
          _buildInfoRow(Icons.attach_money, "Per Hour Payment:", payment),
          _buildInfoRow(Icons.description, "Description:", description),
          const SizedBox(height: 40),
          Center(
            child: ElevatedButton(

                  onPressed: () async {
                    String notificationMessage = "Your vacancy has received a request.";

                    // Fetch the customerId from the Vacancy collection based on the vacancyId (ownerId in this case)
                    DocumentSnapshot vacancyDoc = await FirebaseFirestore.instance.collection("Vacancy").doc(ownerId).get();

                    // Make sure the customerId exists in the Vacancy document
                    String customerId = vacancyDoc['Customer Id'];  // This field should be 'Customer Id'

                    // Send notification to the customer who posted the vacancy
                    await FirebaseFirestore.instance.collection("Notifications").add({
                      "vacancyId": ownerId,  // The vacancy that got the request
                      "customerId": customerId,  // The customer who created the vacancy
                      "message": notificationMessage,
                      "timestamp": FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Request sent successfully!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text("Request"),


            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black54),
              ),
              child: Text(value, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
