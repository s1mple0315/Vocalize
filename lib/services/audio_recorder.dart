import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _recorder.openRecorder();
      _isInitialized = true;
    }
  }

  Future<void> startRecording() async {
    if (!await Permission.microphone.request().isGranted) {
      throw Exception('Microphone permission denied');
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: path);
    print('Recording started: $path');
  }

  Future<String?> stopRecording() async {
    final String? path = await _recorder.stopRecorder();
    print('Recording stopped: $path');
    return path;
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }
}
