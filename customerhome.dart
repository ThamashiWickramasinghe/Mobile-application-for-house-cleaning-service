import 'package:flutter/material.dart';
import 'addvacancy.dart';
import 'updatevacancy.dart';
import 'review.dart';
import 'customernotification.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("images/logo.jpg"), // Your company logo
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blueGrey),
            onPressed: () {
              // Navigate to Notifications Page
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerNotification()));
            },
          ),
        ],
        title: Text(
          "Shine Cleaning Agency",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCategoryCard(
                context,
                "Add New Vacancy",
                "images/addvacancy.jpg",
                Color(0xffFFF7CC),
                AddVacancy()
            ),
            _buildCategoryCard(
                context,
                "Update or Delete Vacancy",
                "images/update.jpg",
                Color(0xffFADADD),
                UpdateVacancy()
            ),
            _buildCategoryCard(
                context,
                "Review Section",
                "images/review.jpg",
                Color(0xffC8E6C9),
                Review()
            ),
            _buildCategoryCard(
                context,
                "Notification Section",
                "images/notification.jpg",
                Color(0xffB3E5FC),
                CustomerNotification()
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a styled category card
  Widget _buildCategoryCard(
      BuildContext context, String title, String imagePath, Color bgColor, Widget nextPage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => nextPage),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blueGrey),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text("Open", style: TextStyle(color: Colors.blueGrey)),
                ),
              ],
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black26),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
