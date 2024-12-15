import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  // Dummy data for users
  final List<User> users = [
    User(name: 'Robbin J.', country: 'United States', score: 5000, flagUrl: 'assets/flags/us.png'),
    User(name: 'Lily W.', country: 'China', score: 4500, flagUrl: 'assets/flags/cn.png'),
    User(name: 'Kunal S.', country: 'India', score: 2000, flagUrl: 'assets/flags/in.png'),
    User(name: 'Emily L.', country: 'United States', score: 1500, flagUrl: 'assets/flags/us.png'),
    User(name: 'Kate W.', country: 'United Kingdom', score: 1400, flagUrl: 'assets/flags/gb.png'),
    User(name: 'Thomas M.', country: 'Germany', score: 1200, flagUrl: 'assets/flags/de.png'),
    User(name: 'Pedro A.', country: 'Brazil', score: 1100, flagUrl: 'assets/flags/br.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text('${index + 1}. ${user.name}'),
            subtitle: Text(user.country),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${user.score}'),
                Icon(Icons.local_fire_department, color: Colors.red)
              ],
            ),
          );
        },
      ),
    );
  }
}

class User {
  final String name;
  final String country;
  final int score;
  final String flagUrl;

  User({required this.name, required this.country, required this.score, required this.flagUrl});
}
