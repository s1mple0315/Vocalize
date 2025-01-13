import 'package:flutter/material.dart';

class TranscriptionsPage extends StatelessWidget {
  const TranscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transcriptions'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: 0, // Replace with actual transcriptions count later
        itemBuilder: (context, index) {
          // Placeholder for individual transcription item
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text('Transcription #$index'),
              subtitle: const Text('Transcription preview text...'),
              onTap: () {
                // TODO: Handle interaction for detailed view/editing
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new transcription action
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
