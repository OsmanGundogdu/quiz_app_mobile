import 'package:flutter/material.dart';
import 'package:quiz_app/model/user.dart';
import 'package:quiz_app/screens/leaderboard_screen.dart';
import 'package:quiz_app/screens/quizzes_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userID;

  const UserProfileScreen({super.key, required this.userID});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user;
  List<String> quizTitles = [];
  bool isLoading = true;
  int _selectedindex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      user = await User.userProfile(widget.userID);
      setState(() {
        isLoading = false;
      });
      _screens = [
        QuizListScreen(),
        UserProfileScreen(
          userID: user!.userID!,
        ),
        LeaderboardScreen(),
      ];
    } catch (e) {
      print("Kullanıcı bilgileri çekilirken beklenmeyen bir hata oluştu: $e");
      setState(() {
        user = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("Kullanıcı bulunamadı"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "İsim: ${user?.firstName ?? 'Herhangi bir veri yok...'}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                          "Soyisim: ${user?.lastName ?? 'Herhangi bir veri yok...'}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(
                          "Email: ${user?.email ?? 'Herhangi bir veri yok...'}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      Text("Toplam puan: ${user?.totalScore ?? 0}",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      const Text("Yapılmış Testler:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      user!.quizzes.isEmpty
                          ? const Text("*** Henüz test çözülmedi ***",
                              style: TextStyle(fontSize: 16))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: user!.quizzes
                                  .map((quiz) => Text("- ${quiz.title}",
                                      style: const TextStyle(fontSize: 16)))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
      backgroundColor: Colors.tealAccent,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedindex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedindex = index;
          });
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/profile');
              break;
            case 1:
              Navigator.of(context).pushNamed('/quizlist');
              break;
            case 2:
              Navigator.of(context).pushNamed('/leaderboard');
              break;
          }
        },
        indicatorColor: Colors.tealAccent,
        backgroundColor: Colors.teal,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profilim',
          ),
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard, color: Colors.black),
            label: 'Liderlik Tablosu',
          ),
        ],
      ),
    );
  }
}
