import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Notification page ',style: TextStyle(
              fontWeight: FontWeight.bold,

            ),)
          ],
        ),
      ),
    );
  }
}
