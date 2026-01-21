import 'package:cleanapp/pages/notification.dart';
import 'package:flutter/material.dart';
import 'clean.dart';
import 'repair.dart';
import 'repair.dart';
import 'laundry.dart';
import 'paint.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find the best job vacancies for you",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20.0),

              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for jobs...",
                    prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                        });
                      },
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Horizontal Job Categories with Scroll
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildCategory("Cleaning", "images/clean.jpg", Clean()),
                      SizedBox(width: 20.0),
                      buildCategory("Repairing", "images/repair.jpg", Repair()),
                      SizedBox(width: 20.0),
                      buildCategory("Laundry", "images/Laundry.jpg", Laundry()),
                      SizedBox(width: 20.0),
                      buildCategory("Painting", "images/paint.jpg", Paint()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Recommended Jobs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended Jobs",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),

              // Job Listings
              buildServiceCard(
                title: "House Cleaning Jobs",
                description: "Find the latest house cleaning job vacancies.",
                imagePath: "images/cleaner.jpg",
                page: Clean(),
                color: Colors.blue[100]!,
              ),
              buildServiceCard(
                title: "Repair Jobs",
                description: "Work opportunities for home maintenance experts.",
                imagePath: "images/macanic.jpg",
                page: Repair(),
                color: Colors.green[100]!,
              ),
              buildServiceCard(
                title: "Laundry Jobs",
                description: "Laundry service job openings available now.",
                imagePath: "images/wash.jpg",
                page: Laundry(),
                color: Colors.purple[100]!,
              ),
              buildServiceCard(
                title: "Painting Jobs",
                description: "Join house painting projects and get hired.",
                imagePath: "images/wallpaint.jpg",
                page: Paint(),
                color: Colors.orange[100]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a category item (Navigates to respective page)
  Widget buildCategory(String name, String imagePath, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 130,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                Text(name,
                    style: TextStyle(color: Colors.black, fontSize: 18.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build a service card
  Widget buildServiceCard({
    required String title,
    required String description,
    required String imagePath,
    required Widget page,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(description,
                    style: TextStyle(fontSize: 14),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 10),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueGrey),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => page));
                  },
                  child: Text("Find Jobs",
                    style: TextStyle(color: Colors.blueGrey),),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}