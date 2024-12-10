import 'package:acheive_it/pages/Login%20Signup/Screen/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widget/button.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Congratulation\nYou have successfully Login",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            MyButtons(
                onTap: () async {
                  //await FirebaseServices().googleSignOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                text: "Log Out"),
            // for google sign in ouser detail
            Image.network("${FirebaseAuth.instance.currentUser!.photoURL}"),
            Text("${FirebaseAuth.instance.currentUser!.email}"),
            Text("${FirebaseAuth.instance.currentUser!.displayName}")
          ],
        ),
      ),
    );
  }
}
