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
      appBar: AppBar(
        title: const Text('Recordings'),
      ),
      body: _recordings.isEmpty
          ? const Center(child: Text('No recordings found'))
          : ListView.builder(
              itemCount: _recordings.length,
              itemBuilder: (context, index) {
                final File recording = _recordings[index];
                return ListTile(
                  title: Text(
                    recording.path.split('/').last,
                  ),
                  subtitle: Text(recording.path),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {},
                  ),
                );
              },
            ),
    );
  }
}
