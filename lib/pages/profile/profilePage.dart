import 'package:acheive_it/pages/Login%20Signup/Screen/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:acheive_it/pages/Goals/screens/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  Future<Map<String, dynamic>> _fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId == null) return {};

    // Fetch user details from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // Extract the display name, fallback to Firestore data if needed
    String? userName = user?.displayName;
    if (userName == null || userName.isEmpty) {
      userName = userDoc.data()?['displayName'] as String?;
    }

    // Fetch goals
    final goalsSnapshot = await FirebaseFirestore.instance
        .collection('goals')
        .where('created_user', isEqualTo: userId)
        .get();

    final goals = goalsSnapshot.docs;
    final completedGoals = goals.where((doc) => doc['status'] == true).length;
    final totalGoals = goals.length;

    return {
      'userName': userName ?? 'User',
      'email': user?.email ?? 'No email available',
      'completedGoals': completedGoals,
      'totalGoals': totalGoals,
       // Replace with actual streak calculation logic
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const home()),
          ),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No goals found!",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final profileData = snapshot.data!;
          final userName = profileData['userName'];
          final userEmail = profileData['email'];
          final completedGoals = profileData['completedGoals'];
          final totalGoals = profileData['totalGoals'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                            ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                            : AssetImage('images/default_avatar.jpg') as ImageProvider,
                      ),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userEmail,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => _showLogoutConfirmation(context),
                    child: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildStatCard(completedGoals.toString(), 'Goal achieved'),
                    buildStatCard(totalGoals.toString(), 'Total goals'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _logoutGoogle() async {
    final googleSignIn = GoogleSignIn();
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error during Google logout: $e');
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await FirebaseAuth.instance.signOut();
                await _logoutGoogle();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget buildStatCard(String number, String label, {IconData? icon}) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null
              ? Icon(icon, color: Colors.orange, size: 32)
              : Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
