import 'package:flutter/material.dart';
import 'package:vocalize/ui/pages/main_page.dart';

void main() {
  runApp(const VocalizeApp());
}

class VocalizeApp extends StatelessWidget {
  const VocalizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocalize',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MainPage(),
    );
  }
}
