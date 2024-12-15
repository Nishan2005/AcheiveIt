import 'package:acheive_it/pages/FocusTimer/timerPage.dart';
import 'package:acheive_it/pages/Goals/constraints/colors.dart';
import 'package:acheive_it/pages/Goals/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeeGoalsScreen extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;

  SeeGoalsScreen({required this.categoryTitle, required this.categoryId});

  @override
  _SeeGoalsScreenState createState() => _SeeGoalsScreenState();
}

class _SeeGoalsScreenState extends State<SeeGoalsScreen>
    with SingleTickerProviderStateMixin {
  final CollectionReference goalsRef =
  FirebaseFirestore.instance.collection('goals');

  Map<String, bool> selectedGoals = {}; // Tracks checkbox statuses
  Map<String, bool> showDropdown = {}; // Tracks dropdown visibility statuses
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchInitialGoalStatuses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch initial statuses for all goals in the category
  Future<void> _fetchInitialGoalStatuses() async {
    QuerySnapshot snapshot = await goalsRef
        .where('category', isEqualTo: widget.categoryId)
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
      BuildContext context, QueryDocumentSnapshot doc, String goalType, int index) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final String goal = data['goals'] ?? 'Untitled Goal';
    final String subtitle = data['subtitle'] ?? 'No subtitle available';
    final bool isSelected = selectedGoals[doc.id] ?? false;
    final bool isDropdownVisible = showDropdown[doc.id] ?? false;

    final Timestamp timestamp = data['end_date'] ?? Timestamp.now();
    final DateTime endDate = timestamp.toDate();
    final String formattedEndDate = DateFormat('MMM dd, yyyy').format(endDate);

    return Column(
        children: [
          ListTile(
            title: GestureDetector(
              onTap: () {
                setState(() {
                  showDropdown[doc.id] = !(showDropdown[doc.id] ?? false);
                });
              },
              child: Text(
                '$index. $subtitle',
                style: TextStyle(
                  color: isSelected ? tdPrimary : Colors.black,
                  decoration: isSelected ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) async {
                // Update the local selection state
                setState(() {
                  selectedGoals[doc.id] = value ?? false;
                });
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const home()), // Make sure 'home' is your HomePage widget
                      (route) => false,  // This condition will remove all previous routes
                );

                // Update Firestore with the new status
                try {
                  await goalsRef.doc(doc.id).update({'status': value});
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update status: $error'),
                    ),
                  );
                }

                // Trigger a reload of the home page (without creating new page stack)
                // Instead of navigating directly, just trigger the reload by calling setState on home.
                setState(() {
                  // This triggers UI refresh with new Firestore data
                });

                // Optionally, navigate to the home page, especially if required to "reset" state
                // Use the home screen widget you already defined to reload its content.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => home()), // Ensure HomePage widget triggers the needed state refresh
                );
              },
            ),
          ),


          if (isDropdownVisible && goalType == 'Small Goal')
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGoalsList(String goalType) {
    return StreamBuilder<QuerySnapshot>(
      stream: goalsRef
          .where('category', isEqualTo: widget.categoryId)
          .where('goal_type', isEqualTo: goalType)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No $goalType goals found for this category.",
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
              child: _buildGoalItem(context, doc, goalType, index + 1),
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
        title: Text(widget.categoryTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Big Goals"),
            Tab(text: "Small Goals"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGoalsList('Big Goal'),
          _buildGoalsList('Small Goal'),
        ],
      ),
    );
  }
}
