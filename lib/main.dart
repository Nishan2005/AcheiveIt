import 'package:acheive_it/pages/Login%20Signup/Screen/LandingPage.dart';
import 'package:acheive_it/pages/Login%20Signup/Screen/login.dart';
import 'package:acheive_it/pages/Login%20Signup/Screen/loginPage.dart';
import 'package:acheive_it/pages/Login%20Signup/Screen/signupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     initialRoute: '/',
  //     routes: {
  //       '/': (context) => LandingPage(),
  //       '/signin': (context) => SignUpPage(),
  //       '/login': (context) => LoginPage(),
  //     },
  //   );
  // }
}
