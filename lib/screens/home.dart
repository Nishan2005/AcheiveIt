import 'package:acheive_it/widgets/bottomNavigation.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwLOO_ZbFmHlHIE2lpbitsU6v-528Ms3cWXA&s') // Add your avatar
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello Alesha!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400,color: tdText),
            ),
            const SizedBox(height: 16),
            // Tabs for Overview and Productivity
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0; // Set "Overview" tab as active
                    });
                  },
                  child: CustomTab(
                    label: "Overview",
                    isActive: selectedIndex == 0, // Active if index matches
                  ),
                ),

                // Tab 2
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1; // Set "Productivity" tab as active
                    });
                  },
                  child: CustomTab(
                    label: "Productivity",
                    isActive: selectedIndex == 1, // Active if index matches
                  ),
                ),

              ],
            ),
            const SizedBox(height: 16),
            // Daily Progress Section
            ProgressCard(progress: 20),
            const SizedBox(height: 16),

            // Categories Section
            const Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('Categories').get(),
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
                      final progress = (category['progress'] ?? 0);
                      // final indicator = 1.0;
                      final percentage = progress/100;


                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: tdLessGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              children: [
                                // LinearProgressIndicator
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: percentage, // The progress value divided by 100 to get a percentage
                                    color: tdPrimary,
                                    backgroundColor: Colors.white,
                                  ),
                                ),

                                const SizedBox(width: 8), // Space between progress bar and text

                                // Text showing progress percentage
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    color: tdGrey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text("${progress}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w100),), // Showing progress as percentage
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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





