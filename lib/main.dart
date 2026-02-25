import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Planner App',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
