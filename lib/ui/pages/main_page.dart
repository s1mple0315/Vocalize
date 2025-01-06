import 'package:flutter/material.dart';
import 'package:vocalize/services/audio_recorder.dart';
import 'package:vocalize/ui/pages/recordings_page.dart';
import 'package:vocalize/ui/widgets/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder.initialize();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    const Center(
      child: Text('Dictaphone functionality will be here',
        style: TextStyle(fontSize: 18),),
    ),
    const RecordingsPage()
  ];

  void onTabSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void toggleRecording() async {
    setState(() {
      isRecording = !isRecording;
    });

    if (isRecording) {
      await _audioRecorder.startRecording();
      print("Recording started");
    } else {
      final path = await _audioRecorder.stopRecording();
      print('Saved recording at: $path');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocalize'),
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: onTabSelected,
      ),
    );
  }
}
