import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:vocalize/services/audio_recorder.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentRecordingPath;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      await _audioRecorder.initialize();
    } catch (e) {
      debugPrint('Error initializing recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      await _audioRecorder.startRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _showErrorDialog('Failed to start recording', e.toString());
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stopRecording();
      setState(() {
        _isRecording = false;
        _currentRecordingPath = path;
      });

      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved: $path')),
        );

        Timer(const Duration(seconds: 3), () {
          setState(() {
            _currentRecordingPath = null;
          });
        });
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _showErrorDialog('Failed to stop recording', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            const Text('Record Audio', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: _isRecording ? Colors.red : Colors.white,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              animate: _isRecording,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                ),
                child: IconButton(
                  iconSize: 100,
                  icon: Icon(
                    _isRecording ? Icons.mic_off : Icons.mic,
                    color: _isRecording ? Colors.red : Colors.white,
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ),
            ),
            if (_currentRecordingPath != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Last recording saved at:\n$_currentRecordingPath',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }
}
