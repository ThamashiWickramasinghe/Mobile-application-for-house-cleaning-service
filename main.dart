
import 'package:cleanapp/pages/addvacancy.dart';
import 'package:cleanapp/pages/bottom_nav.dart';
import 'package:cleanapp/pages/clean.dart';
import 'package:cleanapp/pages/customer_profile.dart';
import 'package:cleanapp/pages/customerhome.dart';
import 'package:cleanapp/pages/home.dart';
import 'package:cleanapp/pages/laundry.dart';
import 'package:cleanapp/pages/paint.dart';
import 'package:cleanapp/pages/login.dart';
import 'package:cleanapp/pages/profile.dart';
import 'package:cleanapp/pages/repair.dart';
import 'package:cleanapp/pages/updatevacancy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cleanapp/pages/signup.dart';
import 'package:cleanapp/pages/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Add this import for kIsWeb

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Corrected the typo here

  if (kIsWeb) {
    // Firebase options for web platform
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDRCny9Q8fOJNqY52xT6kLpiVwXf83bySM",
        authDomain: "testproj-bdf93.firebaseapp.com",
        projectId: "testproj-bdf93",
        storageBucket: "testproj-bdf93.appspot.com", // Corrected the storage bucket URL format
        messagingSenderId: "999758844496",
        appId: "1:999758844496:web:5b365493c5426e3e653755",
      ),
    );
  } else {
    // Firebase initialization for non-web platforms (e.g., Android, iOS)
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Start your app with the appropriate initial screen
      home: LogIn(), // Change this to your desired home page widget
    );
  }
}
