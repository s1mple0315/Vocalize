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
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Record'),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_music), label: 'Recordings'),
      ],
    );
  }
}
