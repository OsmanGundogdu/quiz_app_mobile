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
        foregroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
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
              int totalScore = user['totalScore'] ?? 0;

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowUserProfileScreen(
                            userID: user['id'],
                          ),
                        ));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.yellow[700] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$firstname $lastname",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Text("Puan: $totalScore"),
                              ],
                            ),
                          ],
                        ),
                        if (index == 0)
                          Image.asset(
                            'assets/crown.png',
                            width: 30,
                            height: 30,
                          ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
      backgroundColor: Colors.grey,
    );
  }
}
