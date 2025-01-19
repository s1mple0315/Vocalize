import 'package:flutter/material.dart';

class TranscriptionsPage extends StatelessWidget {
  const TranscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Transcriptions', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: 0, // Replace with actual transcriptions count later
        itemBuilder: (context, index) {
          // Placeholder for individual transcription item
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Transcription #$index', style: const TextStyle(fontSize: 18.0, color: Colors.white)),
              subtitle: const Text('Transcription preview text...', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
              onTap: () {
                // TODO: Handle interaction for detailed view/editing
              },
            ),
          );
        },
      ),
    );
  }
}
