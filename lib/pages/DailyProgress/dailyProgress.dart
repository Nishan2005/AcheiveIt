import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily progress"),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('goals').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No goals found!",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final goals = snapshot.data!.docs;
          final completedGoals = goals.where((doc) => doc['status'] == true && doc['created_user'] == FirebaseAuth.instance.currentUser?.uid).toList();
          final totalgetTasks = goals.where((doc) =>doc['created_user'] == FirebaseAuth.instance.currentUser?.uid).toList();
          final completedTasks = completedGoals.length;
          final totalTasks = totalgetTasks.length;
          final productivity = totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoCard("Tasks", "$completedTasks/$totalTasks"),
                    //_buildInfoCard("Time", "1h40m"), // Replace with actual time data
                  ],
                ),
                // const SizedBox(height: 16),
                // Row(
                //   children: [
                //     _buildInfoCard("Focus", "20m"), // Replace with actual focus time data
                //   ],
                // ),
                const SizedBox(height: 32),
                Text("Productivity", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: productivity,
                        color: Colors.purple,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text("${(productivity * 100).toStringAsFixed(0)}%"),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Keep going!",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),
                Text(
                  "Summary",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("You've completed $completedTasks tasks today."),
                Text("Your longest focus session was 20 minutes."), // Replace with actual focus time data
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
