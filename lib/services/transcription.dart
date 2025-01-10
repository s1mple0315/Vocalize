// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter/services.dart';

// class AudioTranscriptionService {
//   final SpeechToText _speechToText = SpeechToText();

//   Future<String> transcribeAudio(String filePath) async {
//     try {
//       bool available = await _speechToText.initialize();
//       if (!available) {
//         return 'Speech-to-Text service is not available.';
//       }

//       // Sending the file to the recognition service
//       ByteData fileData = await rootBundle.load(filePath);
//       bool sent = await _speechToText.sendFile(filePath, fileData.buffer.asUint8List());
//       if (!sent) {
//         return 'Failed to send audio file for transcription.';
//       }

//       final result = await _speechToText.start();

//       if (result.recognizedWords.isNotEmpty) {
//         return result.recognizedWords;
//       } else {
//         return 'No words recognized.';
//       }
//     } catch (e) {
//       return 'Error during transcription: $e';
//     } finally {
//       await _speechToText.stop();
//     }
//   }
// }
