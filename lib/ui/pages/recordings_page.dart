import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vocalize/services/audio_recorder.dart';

class RecordingsPage extends StatefulWidget {
  @override
  _RecordingsPageState createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  final AudioRecorder _recorder = AudioRecorder();
  List<File> _recordings = [];

  @override
  void initState() {
    super.initState();
    _fetchRecordings();
  }

  Future<void> _fetchRecordings() async {
    await _recorder.initialize();
    final List<File> recordings = await _recorder.listRecordings();
    setState(() {
      _recordings = recordings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Recordings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _recordings.isEmpty
          ? const Center(
              child: Text(
              'No recordings found',
              style: TextStyle(color: Colors.white),
            ))
          : ListView.separated(
              itemCount: _recordings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final File recording = _recordings[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900],
                  ),
                  child: ListTile(
                    title: Text(
                      recording.path.split('/').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
    );
  }
}
