

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'HomePage.dart';
import 'ListedItem.dart';
import 'SplashScreen.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize with the generated options
  );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

       // home:  SplashScreen(),
      // home: HomePage(),
      // home: ItemListed(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If the user is authenticated, show the Dashboard
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return HomePage(); // Navigate to Dashboard if the user is logged in
            } else {
              return SplashScreen(); // Navigate to Login if the user is not logged in
            }
          }
          // Loading screen while checking the authentication state
          return Center(child: CircularProgressIndicator());
        },
      ),

    );
    }
}

