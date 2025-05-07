

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'AddItemScreen.dart';
// import 'DonationItems.dart';
// import 'HomePage.dart';

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

       home:  SplashScreen(),
      // home: AddItemScreen(),
     // // home: TestLoginStallScreen(),
     //    home:  HomePage(),
     // // home: LoginEmailScreen(),
     // //  home: RegisterEmail(),
      // In your main.dart file, ensure you have routes set up:




    );
    }
}

