import 'package:acheive_it/pages/Goals/screens/addGoal2.dart';
import 'package:acheive_it/pages/Goals/screens/collabGoalDisplay.dart';
import 'package:acheive_it/pages/notifications/screens/notificationsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customButtonNavigation extends StatelessWidget {
  const customButtonNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '',
        ),
       BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
        }
        if (index == 1) {
          // Navigate to AddGoalScreen when the second item (add icon) is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGoalScreen()),
          );
        }
        if (index == 2) {
          // Navigate to AddGoalScreen when the second item (add icon) is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyGoalsPage()),
          );
        }
      },
    );
  }
}
