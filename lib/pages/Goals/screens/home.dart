import 'package:acheive_it/pages/Goals/screens/seeGoalsScreen.dart';
import 'package:acheive_it/pages/Goals/widgets/bottomNavigation.dart';
import 'package:acheive_it/pages/apiQuote/api.dart';
import 'package:acheive_it/pages/apiQuote/quote_model.dart';
import 'package:acheive_it/pages/profile/profilePage.dart';
import 'package:acheive_it/pages/DailyProgress/dailyProgress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';

import '../constraints/colors.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int selectedIndex = 0;
  final CollectionReference goalsRef =
  FirebaseFirestore.instance.collection('goals');
  // TextController for new category input
  TextEditingController _categoryController = TextEditingController();
  double progress = 0.0; // Holds the calculated progress
  bool isLoading = true; // To manage loading state
  String errorMessage = ''; // For any errors
  bool inProgress = false;
  QuoteModel? quote;

  @override
  void initState() {
    super.initState();
    _fetchQuote();
    _fetchGoalsData();  // Fetch the data on widget load
  }

  _fetchQuote() async {
    setState(() {
      inProgress = true;
    });
    try {
      final fetchedQuote = await Api.fetchRandomQuote();
      debugPrint(fetchedQuote.toJson().toString());
      setState(() {
        quote = fetchedQuote;
      });
    } catch (e) {
      debugPrint("Failed to generate quote");
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
  // Fetches the goals data and calculates the progress
  Future<void> _fetchGoalsData() async {
    setState(() {
      isLoading = true; // Set loading to true while fetching
      errorMessage = ''; // Clear previous error messages
    });

    try {
      final snapshot = await FirebaseFirestore.instance.collection('goals').get();

      if (snapshot.docs.isNotEmpty) {
        final goals = snapshot.docs;
        final total = goals.where((doc)=> doc['created_user'] == FirebaseAuth.instance.currentUser?.uid).toList();
        final completedGoals = goals.where((doc) {
          return doc['status'] == true && doc['created_user'] == FirebaseAuth.instance.currentUser?.uid;
        }).toList();
        final totalTasks = total.length;
        final completedTasks = completedGoals.length;

        setState(() {
          progress = totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0; // Calculate the progress
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          isLoading = false; // Set loading to false if no data found
          errorMessage = 'No goals found!'; // Error message if no goals in database
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false on error
        errorMessage = 'Error fetching data: $e'; // Display the error
      });
    }
  }

  // Fetch initial statuses for all goals in the category

  Future<Map<String, int>> fetchGoalCounts(String categoryId) async {
    try {
      final goalsSnapshot = await FirebaseFirestore.instance
          .collection('goals')
          .where('category', isEqualTo: categoryId)
          .get();

      final totalGoals = goalsSnapshot.docs.length;
      final goalsWithStatusTrue = goalsSnapshot.docs
          .where((doc) => (doc['status'] ?? false) == true)
          .length;

      return {
        'totalGoals': totalGoals,
        'goalsWithStatusTrue': goalsWithStatusTrue,
      };
    } catch (e) {
      throw Exception('Error fetching goals: $e');
    }
  }



  // Function to show the add category dialog
  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: _categoryController,
          decoration: const InputDecoration(labelText: 'Category Title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add the new category to Firestore
              if (_categoryController.text.isNotEmpty) {
                FirebaseFirestore.instance.collection('Categories').add({
                  'title': _categoryController.text.trim(),
                  'progress': 0,
                  'user_id': FirebaseAuth.instance.currentUser?.uid// Default progress
                }).then((_) {
                  // Close the dialog and clear the controller
                  Navigator.of(ctx).pop();
                  _categoryController.clear();
                  setState(() {}); // Rebuild the widget to show new category
                });
              }
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog without adding
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  // final bool isActive = false;
  @override
  Widget build(BuildContext context) {
         return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: const Text('Achievelt', style: TextStyle(fontSize: 30, fontFamily: 'Roboto', fontWeight: FontWeight.w600),),
        backgroundColor: tdBGColor,
        foregroundColor: tdText,
        elevation: 0,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {},
          // ),
          InkWell(
            onTap: () {
              // Handle tap event here, for example:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              // You can navigate to a profile page or show a dialog, etc.
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                  ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                  : AssetImage('images/default_avatar.jpg') as ImageProvider,
            ),
          ),

        ],
      ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello " + (FirebaseAuth.instance.currentUser?.displayName ?? 'Guest') + "!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: tdText),
            ),
            const SizedBox(height: 16),
            // Tabs for Overview and Productivity
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuoteCard(
                  quote: quote?.q ?? "Loading...",
                  author: quote?.a ?? "Unknown",
                  inProgress: inProgress,
                  onGenerate: _fetchQuote,
                ),
              ),
            ),
            const SizedBox(height: 16),
            //Daily Progress
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyProgressPage()),
                );
              },
              child: ProgressCard(progress: progress),
            ),
            const SizedBox(height: 16),

            // Categories Section
            const Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Add Category Button
            ElevatedButton(
              onPressed: _showAddCategoryDialog,
              child: const Text('Add Category'),
              style: ElevatedButton.styleFrom(iconColor: tdPrimary),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('Categories')
                  .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching data'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('There is no data here'),
                  );
                }


                final categories = snapshot.data!.docs;

                return Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 40,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final title = category['title'] ?? 'Untitled';
                      final Id = category.id ?? '';

                      return FutureBuilder<Map<String, int>>(
                        future: fetchGoalCounts(Id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(
                              child: Text('No data available'),
                            );
                          }

                          final data = snapshot.data!;
                          final totalGoals = data['totalGoals']!;
                          final goalsWithStatusTrue = data['goalsWithStatusTrue']!;
                          final progress = totalGoals > 0 ? (goalsWithStatusTrue / totalGoals) : 0.0; // Prevent division by zero
                          final percentage = (progress * 100).toStringAsFixed(1); // Format percentage string

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeeGoalsScreen(
                                    categoryTitle: title,
                                    categoryId: Id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: tdLessGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("New Goals"),
                                  const SizedBox(height: 8),
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Linear Progress Bar
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          color: tdPrimary,
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Text showing progress percentage
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: tdGrey,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$percentage%", // Show progress percentage
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );


              },
            ),

          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: customButtonNavigation()
    );
  }
}

class CustomTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const CustomTab({Key? key, required this.label, required this.isActive, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(

      child: Container(
          margin: const EdgeInsets.all(5),

        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 25),
        decoration: BoxDecoration(
          color: isActive ? tdGrey : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: tdGrey),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),

    );
  }
}


class ProgressCard extends StatelessWidget {
  final double progress;

  const ProgressCard({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: tdLessGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Progress",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: tdText,
            ),
          ),
          const SizedBox(height: 8),
          const Text("Track your daily goals progress here"),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "${progress.toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: progress / 100,
                  color: tdPrimary,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final bool inProgress;
  final VoidCallback onGenerate;

  const QuoteCard({
    Key? key,
    required this.quote,
    required this.author,
    required this.inProgress,
    required this.onGenerate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Adjust card background color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Motivational Quote",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            quote,
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontFamily: 'monospace',
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "- $author",
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'serif',
              color: Colors.black38,
            ),
          ),
          // const SizedBox(height: 16),
          // inProgress
          //     ? const Center(
          //   child: CircularProgressIndicator(),
          // )
          //     : ElevatedButton(
          //   onPressed: onGenerate,
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     side: const BorderSide(color: Colors.grey),
          //   ),
          //   child: const Text(
          //     "Generate New Quote",
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
        ],
      ),
    );
  }
}






