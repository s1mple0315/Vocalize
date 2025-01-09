import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocalize/ui/pages/record_page.dart';
import 'package:vocalize/ui/pages/recordings_page.dart';
import 'package:vocalize/ui/widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.grey[900],
        systemNavigationBarIconBrightness: Brightness.light),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _pages = [
    RecordPage(),
    RecordingsPage()
  ];

  void onTabSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Vocalize', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[800] ?? Colors.grey,
              blurRadius: 10,
              spreadRadius: 3,
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavBar(
            currentIndex: currentIndex,
            onTabSelected: onTabSelected,
          ),
        ),
      ),
    );
  }
}
