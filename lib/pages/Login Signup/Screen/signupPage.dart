import 'package:acheive_it/pages/Goals/screens/home.dart';
import 'package:acheive_it/pages/Login%20Signup/Screen/loginPage.dart';
import 'package:flutter/material.dart';
import '../Services/authentication.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void signupUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar(context, "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const home(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Image.asset('images/login_signup.png'),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFieldInput(
                    icon: Icons.person,
                    textEditingController: nameController,
                    hintText: 'Enter your name',
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    icon: Icons.email,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(height: 20),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: confirmPasswordController,
                    hintText: 'Confirm your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: signupUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB39DCE),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 100),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text('Sign Up',
                      style: TextStyle(
                      color: Colors.white,  // Set the text color to white
                      fontSize: 18.0,       // Set the font size to make it bigger
                      fontWeight: FontWeight.bold, // Optional: Make it bold if needed
                    ),),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
