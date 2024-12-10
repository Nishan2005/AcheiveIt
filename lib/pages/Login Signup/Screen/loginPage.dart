import 'package:acheive_it/pages/Login%20Signup/Screen/forgotPass.dart';
import 'package:acheive_it/pages/Login%20Signup/Screen/signupPage.dart';
import 'package:acheive_it/pages/Login%20Signup/Services/google_auth.dart';
import 'package:acheive_it/pages/Login%20Signup/Widget/snackbar.dart';
import 'package:acheive_it/pages/Login%20Signup/Services/authentication.dart';
import 'package:flutter/material.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';
import 'login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
            Container(
              margin: EdgeInsets.only(top: 50),
              child: SizedBox(
                //margin: const EdgeInsets.only(top: 100),
                height: 200,
                    child: Image.asset('images/landing_image.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFieldInput(
                    icon: Icons.email,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                  ),
                  // TextField(
                  //   controller: emailController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Email',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  // TextField(
                  //   controller: passwordController,
                  //   obscureText: true,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Password',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(height: 5),

                  Align(
                    alignment: Alignment.centerRight,
                    child:const ForgotPassword(),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7C65A8),
                        foregroundColor: Colors.white70, // Text color
                        padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 100),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic, // Italic style
                      )
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text('Login'),

                  ),
                  const SizedBox(height: 20),
              Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                ),
                const Text("  or  "),
                Expanded(
                  child: Container(height: 1, color: Colors.black26),
                )
              ],
            ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseServices().signInWithGoogle();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.gpp_good_sharp, color: Colors.red),
                    label: const Text('Sign in with Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
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
