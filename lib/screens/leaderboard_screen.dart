import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/screens/show_user_profile_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
    QuerySnapshot usersSnapshot = await _firestore
        .collection('users')
        .orderBy('totalScore', descending: true)
        .get();

    List<Map<String, dynamic>> leaderboard = [];

    for (var userDoc in usersSnapshot.docs) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      userData['id'] = userDoc.id;
      leaderboard.add(userData);
    }

    return leaderboard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LİDERLİK TABLOSU",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Sanırım bir şeyler yanlış gitti :("));
          }

          List<Map<String, dynamic>> leaderboard = snapshot.data!;

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              var user = leaderboard[index];
              String firstname = user['firstname'] ?? 'Bilinmiyor';
              String lastname = user['lastname'] ?? 'Bilinmiyor';
              int totalScore = user['totalScore'];
              return ListTile(
                title: Text("$firstname $lastname"),
                subtitle: Text("Puan: $totalScore"),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowUserProfileScreen(
                        userID: user['id'],
                      ),
                    ),
                  )
                },
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey,
    );
  }
}
