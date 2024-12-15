import 'package:acheive_it/pages/Goals/screens/addColabGoal.dart';
import 'package:acheive_it/pages/Goals/screens/colabGoalDetails.dart';
import 'package:acheive_it/pages/Goals/widgets/bottomNavigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyGoalsPage extends StatefulWidget {
  final String? userEmail = FirebaseAuth.instance.currentUser?.email;

  MyGoalsPage({Key? key}) : super(key: key);

  @override
  _MyGoalsPageState createState() => _MyGoalsPageState();
}

class _MyGoalsPageState extends State<MyGoalsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchUserGoals() async {
    List<Map<String, dynamic>> userGoals = [];

    // Step 1: Fetch userGoalProgress for the logged-in user
    QuerySnapshot progressSnapshot = await _firestore
        .collection('userGoalProgress')
        .where('userId', isEqualTo: widget.userEmail)
        .get();

    for (var progressDoc in progressSnapshot.docs) {
      final progressData = progressDoc.data() as Map<String, dynamic>;
      final goalId = progressData['goalId'];

      // Step 2: Fetch the goal details from collaborativeGoals collection
      DocumentSnapshot goalSnapshot = await _firestore
          .collection('collaborativeGoals')
          .doc(goalId)
          .get();

      if (goalSnapshot.exists) {
        final goalData = goalSnapshot.data() as Map<String, dynamic>;

        // Combine progress and goal data
        userGoals.add({
          'goalId': goalId,
          'goalName': goalData['name'],
          'goalDescription': goalData['description'],
          'collaborators': goalData['collaborators'],
          'progress': progressData['progress'],
          'assignedAt': progressData['assignedAt'],
        });
      }
    }

    return userGoals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Collaborative Goals"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUserGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Failed to load goals: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No collaborative goals found."));
          }

          final goals = snapshot.data!;

          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(goal['goalName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(goal['goalDescription']),
                      SizedBox(height: 8.0),
                      Text("Collaborators: ${goal['collaborators']}"),
                      if (goal['assignedAt'] != null)
                        Text(
                          "Assigned: ${(goal['assignedAt'] as Timestamp).toDate()}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalDetailsPage(
                          goalId : goal['goalId']
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Collaborative Goal page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCollaborativeGoalPage(), // Replace with the AddGoalPage widget
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: "Add Collaborative Goal",
      ),
        // Bottom Navigation Bar
        bottomNavigationBar: customButtonNavigation()
    );

  }
}




