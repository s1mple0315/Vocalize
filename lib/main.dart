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
      debugShowCheckedModeBanner: false,
      title: 'Vocalize',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        primarySwatch: Colors.grey,
      ),
      home: const MainPage(),
    );
  }
}
