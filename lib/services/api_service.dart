import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      "http://172.16.11.29:5000"; // Replace with your server IP and port

  /// Uploads an audio file to the server for transcription.
  Future<Map<String, dynamic>> transcribeFile(File file) async {
    final url = Uri.parse('$baseUrl/transcribe/');

    try {
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('audio', 'wav'),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        if (jsonResponse is Map<String, dynamic>) {
          return jsonResponse; // Return the whole response for flexibility
        } else {
          throw Exception('Unexpected response format.');
        }
      } else {
        throw Exception(
            'Failed to transcribe file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in transcribeFile: $e');
      throw Exception('Failed to connect to the server.');
    }
  }

  /// Saves a transcription to local storage using SharedPreferences.
  Future<void> _saveTranscription(String filePath, String transcription) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> savedTranscriptions = {};

    // Load existing transcriptions
    final existingData = prefs.getString('transcriptions');
    if (existingData != null) {
      savedTranscriptions = Map<String, String>.from(jsonDecode(existingData));
    }

    // Add or update the transcription
    savedTranscriptions[filePath] = transcription;

    // Save updated data back to SharedPreferences
    await prefs.setString('transcriptions', jsonEncode(savedTranscriptions));
  }

  /// Loads all saved transcriptions from SharedPreferences.
  Future<Map<String, String>> loadAllTranscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('transcriptions');

    if (savedData != null) {
      return Map<String, String>.from(jsonDecode(savedData));
    }

    return {};
  }

  /// Deletes a transcription from local storage.
  Future<void> deleteTranscription(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('transcriptions');

    if (savedData != null) {
      final Map<String, String> savedTranscriptions =
          Map<String, String>.from(jsonDecode(savedData));

      // Remove the transcription by file path
      savedTranscriptions.remove(filePath);

      // Save the updated data back to SharedPreferences
      await prefs.setString('transcriptions', jsonEncode(savedTranscriptions));
    }
  }
}
