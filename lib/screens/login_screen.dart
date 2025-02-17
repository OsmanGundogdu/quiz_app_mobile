import 'package:flutter/material.dart';
import 'package:quiz_app/model/user.dart';
import 'package:quiz_app/screens/_layout.dart';
import 'package:quiz_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<User?> _fetchUserData(String mail, String pass) async {
    try {
      return await User.userLogin(context, mail, pass);
    } catch (e) {
      print("Kullanıcı bilgileri çekilirken beklenmeyen bir hata oluştu: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black)),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                  labelText: "Şifre",
                  labelStyle: TextStyle(color: Colors.black)),
              style: TextStyle(color: Colors.black),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                emailController.text;
                passwordController.text;
                User? user = await _fetchUserData(
                    emailController.text, passwordController.text);
                if (user == null) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Layout(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                "Giriş Yap",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  "Henüz hesabın yok mu? Hemen kayıt ol!",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 104, 93),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
