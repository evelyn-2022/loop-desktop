import 'package:flutter/material.dart';
import 'package:loop/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text('Welcome to the Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate using named route
          Navigator.pushNamed(context, AppRoutes.login);
        },
        child: Icon(Icons.login),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
