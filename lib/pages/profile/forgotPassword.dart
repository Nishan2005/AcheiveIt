// import 'package:acheive_it/pages/Login%20Signup/Widget/snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final TextEditingController emailController = TextEditingController();
//   final FirebaseAuth auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 35),
//       child: Align(
//         alignment: Alignment.centerRight,
//
//         child: ElevatedButton(
//           onPressed: () => _showForgotPasswordDialog(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.purple, // Button color
//             foregroundColor: Colors.black, // Text color
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8), // Rounded corners
//             ),
//             elevation: 3, // Optional shadow effect
//           ),
//           child: Text(
//             "Forgot Password?",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//             ),
//           ),
//         )
//         ),
//       );
//   }
//
//   void _showForgotPasswordDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox.shrink(),
//                     const Text(
//                       "Forgot Your Password",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 TextField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Enter the Email",
//                     hintText: "e.g., abc@gmail.com",
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue, // Button color
//                   ),
//                   onPressed: () async {
//                     await _sendPasswordResetEmail(context);
//                   },
//                   child: const Text(
//                     "Send",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _sendPasswordResetEmail(BuildContext context) async {
//     try {
//       await auth.sendPasswordResetEmail(email: emailController.text);
//       showSnackBar(context, "We have sent you the reset password link to your email. Please check it.");
//       Navigator.pop(context); // Close the dialog
//       emailController.clear(); // Clear the text field
//     } catch (error) {
//       showSnackBar(context, error.toString());
//     }
//   }
// }
