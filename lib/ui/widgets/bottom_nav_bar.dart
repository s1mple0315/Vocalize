import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey[900],
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            backgroundColor: Colors.white,
            label: 'Record'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music), label: 'Recordings'),
        BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq), label: 'Transcriptions'),
      ],
    );
  }
}
