import 'package:flutter/services.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

class WhisperTranscriber {
  static const platform = MethodChannel('whisper');

  Future<String> transcribeAudio(String filePath) async {
    try {
      final apiKey = dotenv.DotEnv(includePlatformEnvironment: true)..load()..getOrElse('OPENAI_API_KEY', () => '');
      final result = await platform.invokeMethod('transcribe', {'apiKey': apiKey, 'filePath': filePath});
      return result ?? 'No transcription returned';
    } on PlatformException catch (e) {
      return 'Failed to transcribe: ${e.message}';
    }
  }
}

// Rest of your Flutter code remains the same...