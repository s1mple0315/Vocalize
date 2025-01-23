import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vocalize/models/transcription_model.dart';
import 'package:vocalize/providers/transcription_provider.dart';

class TranscriptionEditor extends StatefulWidget {
  final Transcription transcription;

  const TranscriptionEditor({Key? key, required this.transcription}) : super(key: key);

  @override
  _TranscriptionEditorState createState() => _TranscriptionEditorState();
}

class _TranscriptionEditorState extends State<TranscriptionEditor> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.transcription.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          widget.transcription.name,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _textController.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.share(_textController.text, subject: widget.transcription.name);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Provider.of<TranscriptionProvider>(context, listen: false)
                  .updateTranscription(widget.transcription.id, _textController.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Container(
        color: Colors.grey[900], // Background color outside the editor
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          
          controller: _textController,
          maxLines: null, // Allow multiline editing
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Edit transcription here...',
            hintStyle: TextStyle(color: Colors.grey[900]),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[900], // Background color inside the editor
          ),
        ),
      ),
    );
  }
}
