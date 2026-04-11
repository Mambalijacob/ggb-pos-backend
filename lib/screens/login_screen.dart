import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  void login() async {
    setState(() => loading = true);

    final res = await ApiService.login(username.text, password.text);

    setState(() => loading = false);

    if (res != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(token: res["access_token"]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: username,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: loading ? CircularProgressIndicator() : Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
