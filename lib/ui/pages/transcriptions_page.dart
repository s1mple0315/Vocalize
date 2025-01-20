import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocalize/models/transcription_model.dart';
import 'package:vocalize/providers/transcription_provider.dart';

class TranscriptionsPage extends StatelessWidget {
  const TranscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transcriptionProvider = Provider.of<TranscriptionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Transcriptions', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: transcriptionProvider.transcriptions.isEmpty
          ? const Center(
              child: Text('No transcriptions found', style: TextStyle(color: Colors.white)),
            )
          : ListView.builder(
              itemCount: transcriptionProvider.transcriptions.length,
              itemBuilder: (context, index) {
                final transcription = transcriptionProvider.transcriptions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(transcription.name, style: const TextStyle(fontSize: 18.0, color: Colors.white)),
                    subtitle: Text(transcription.text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                    onTap: () {
                      // Show detailed view or edit options
                      _showTranscriptionDetails(context, transcription);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showTranscriptionDetails(BuildContext context, Transcription transcription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(transcription.name, style: const TextStyle(color: Colors.white)),
        content: SelectableText(
          transcription.text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}