import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://172.16.11.29:5000"; // Replace with your server IP and port

  Future<String> transcribeFile(File file) async {
    var url = Uri.parse('$baseUrl/transcribe/');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('audio', 'wav'),
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        // Save the transcription to local storage
        await _saveTranscription(file.path, jsonResponse['transcription']);
        return jsonResponse['transcription'];
      } else {
        throw Exception('Failed to transcribe file');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> _saveTranscription(String filePath, String transcription) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> savedTranscriptions = {};

    // Load existing data if any
    final existingData = prefs.getString('transcriptions');
    if (existingData != null) {
      savedTranscriptions = Map<String, String>.from(jsonDecode(existingData));
    }

    // Add new transcription
    savedTranscriptions[filePath] = transcription;

    // Save back to SharedPreferences
    await prefs.setString('transcriptions', jsonEncode(savedTranscriptions));
  }

  Future<Map<String, String>> loadAllTranscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('transcriptions');
    if (savedData != null) {
      return Map<String, String>.from(jsonDecode(savedData));
    }
    return {};
  }
}
