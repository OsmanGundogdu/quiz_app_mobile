import 'package:flutter/material.dart';
import 'package:quiz_app/model/user.dart';
import 'package:quiz_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KAYIT OL",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                  labelText: "İsim",
                  labelStyle: TextStyle(color: Colors.black)),
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                  labelText: "Soyisim",
                  labelStyle: TextStyle(color: Colors.black)),
              style: TextStyle(color: Colors.black),
            ),
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
                firstNameController.text;
                lastNameController.text;
                emailController.text;
                passwordController.text;
                var user = await User.userRegister(
                    context,
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    passwordController.text);

                if (user == null) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black),
              ),
              child: const Text(
                "Kayıt Ol",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Zaten hesabın var mı? Hemen giriş yap!",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 104, 93),
                  fontWeight: FontWeight.bold,
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
