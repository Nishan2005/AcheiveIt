// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// //import 'addGoal.dart';
//
// class GoalsScreen extends StatelessWidget {
//   final String title; // Add this field to store the category title
//   final CollectionReference goalsCollection =
//   FirebaseFirestore.instance.collection('goals');
//   // final CollectionReference categoriesCollection =
//   // FirebaseFirestore.instance.collection('Ca');
//
//   GoalsScreen(this.title, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$title Goals'), // Show the category title in the app bar
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               "Goals",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: goalsCollection.snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No goals found. Add a new one!",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }
//
//                 final goals = snapshot.data!.docs;
//
//                 // Filter goals based on the category title
//                 final filteredGoals = goals.where((goal) {
//                   return goal['category'] == title;
//                 }).toList();
//
//                 if (filteredGoals.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No goals found for this category.",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   itemCount: filteredGoals.length,
//                   itemBuilder: (context, index) {
//                     final goal = filteredGoals[index];
//                     return ListTile(
//                       title: Text(goal['title']),
//                       trailing: const Icon(Icons.chevron_right),
//                       onTap: () {
//                         // Navigate to goal details or perform action
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddGoalScreen()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.purple,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Add a goal',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
