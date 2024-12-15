import 'package:acheive_it/pages/FocusTimer/timerPage.dart';
import 'package:acheive_it/pages/Goals/constraints/colors.dart';
import 'package:acheive_it/pages/Goals/screens/addcolabTask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalDetailsPage extends StatefulWidget {
  final String goalId;

  GoalDetailsPage({ required this.goalId});

  @override
  _SeeGoalsScreenState createState() => _SeeGoalsScreenState();
}

class _SeeGoalsScreenState extends State<GoalDetailsPage>
    with SingleTickerProviderStateMixin {
  final CollectionReference goalsRef =
  FirebaseFirestore.instance.collection('collabTask');

  Map<String, bool> selectedGoals = {}; // Tracks checkbox statuses
  Map<String, bool> showDropdown = {}; // Tracks dropdown visibility statuses

  @override
  void initState() {
    super.initState();
    _fetchInitialGoalStatuses();
  }

  // Fetch initial statuses for all goals in the category
  Future<void> _fetchInitialGoalStatuses() async {
    QuerySnapshot snapshot = await goalsRef
        .where('goalId', isEqualTo: widget.goalId)
        .where('created_user', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        selectedGoals[doc.id] = data['status'] ?? false;
      }
    });
  }

  void deleteGoal(String id) {
    goalsRef.doc(id).delete();
  }

  Widget _buildGoalItem(
      BuildContext context, QueryDocumentSnapshot doc, int index) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final String goal = data['goals'] ?? 'Untitled Goal';
    final String subtitle = data['subtitle'] ?? 'No subtitle available';
    final bool isSelected = selectedGoals[doc.id] ?? false;
    final bool isDropdownVisible = showDropdown[doc.id] ?? false;

    final Timestamp timestamp = data['end_date'] ?? Timestamp.now();
    final DateTime endDate = timestamp.toDate();
    final String formattedEndDate = DateFormat('MMM dd, yyyy').format(endDate);

    // Disable the entire row if the checkbox is checked
    final bool isDisabled = isSelected;

    return Column(
      children: [
        ListTile(
          title: GestureDetector(
            onTap: isDisabled
                ? null
                : () {
              setState(() {
                showDropdown[doc.id] = !(showDropdown[doc.id] ?? false);
              });
            },
            child: Text(
              '$index. $subtitle',
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.black,
                decoration: isDisabled ? TextDecoration.lineThrough : null,
                fontWeight: isDisabled ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (value) {
              if (!isDisabled) {
                setState(() {
                  selectedGoals[doc.id] = value ?? false;
                });
                // Update Firestore with the new status
                goalsRef
                    .doc(doc.id)
                    .update({'status': value}).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status: $error'),
                    ),
                  );
                });
              }
            },
          ),
        ),
        if (!isDisabled)
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: tdPrimary,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FocusTimerPage(),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Timer started for "$goal"!'),
                        ),
                      );
                    },
                    icon: Icon(Icons.timer, color: tdPrimary),
                    label: Text("Start Timer"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "End Date: $formattedEndDate",
                    style: TextStyle(fontSize: 6, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

      ],

    );
  }


  Widget _buildGoalsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: goalsRef.where('goalId', isEqualTo: widget.goalId).where('created_user', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No goals found for this category.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            return Dismissible(
              key: Key(doc.id),
              background: Container(color: Colors.red),
              onDismissed: (_) => deleteGoal(doc.id),
              child: _buildGoalItem(context, doc, index + 1),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collab Goal"),
      ),
      body: _buildGoalsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your desired action here
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddColabGoalScreen(goalId: widget.goalId,), // Replace with the AddGoalPage widget
            ),
          );
        },
        backgroundColor: tdPrimary, // You can customize this to any color
        child: Icon(Icons.add), // You can use any icon here
      ),
    );
  }
}
