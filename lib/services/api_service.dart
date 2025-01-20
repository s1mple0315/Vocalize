import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000"; 

  Future<String> transcribeFile(File file) async {
    var url = Uri.parse('$baseUrl/transcribe');

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
        return jsonResponse['transcription'];
      } else {
        throw Exception('Failed to transcribe file');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to connect to the server');
    }
  }
}