
import 'package:flutter/material.dart';
import 'pos_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _username, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _password, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => POSScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
