import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocalize/providers/transcription_provider.dart';
import 'package:vocalize/ui/widgets/transcription_editor.dart';

class TranscriptionsPage extends StatelessWidget {
  const TranscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transcriptionProvider = Provider.of<TranscriptionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Transcriptions', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: transcriptionProvider.transcriptions.isEmpty
          ? const Center(
              child: Text('No transcriptions found', style: TextStyle(color: Colors.white),),
            )
          : ListView.builder(

              itemCount: transcriptionProvider.transcriptions.length,
              itemBuilder: (context, index) {
                final transcription = transcriptionProvider.transcriptions[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    title: Text(transcription.name, style: TextStyle(color: Colors.white),),
                    subtitle: Text(
                      style: TextStyle(color: Colors.white),
                      transcription.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TranscriptionEditor(
                            transcription: transcription,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
