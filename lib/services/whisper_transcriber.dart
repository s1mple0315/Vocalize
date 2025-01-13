import 'package:flutter/services.dart';

class WhisperTranscriber {
  static const platform = MethodChannel('whisper');

  Future<String> transcribeAudio(String filePath) async {
    try {
      final result = await platform.invokeMethod('transcribe', {'filePath': filePath});
      return result ?? 'No transcription returned';
    } on PlatformException catch (e) {
      return 'Failed to transcribe: ${e.message}';
    }
  }
}
