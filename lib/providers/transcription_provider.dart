import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalize/models/transcription_model.dart';

class TranscriptionProvider with ChangeNotifier {
  List<Transcription> _transcriptions = [];

  List<Transcription> get transcriptions => _transcriptions;

  // Load transcriptions from SharedPreferences
  Future<void> loadTranscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('transcriptions');
    if (savedData != null) {
      final List<dynamic> jsonList = jsonDecode(savedData);
      _transcriptions = jsonList.map((e) => Transcription.fromJson(e)).toList();
      notifyListeners();
    }
  }

  // Add a new transcription
  Future<void> addTranscription(String name, String text) async {
    final newTranscription = Transcription(name: name, text: text);
    _transcriptions.add(newTranscription);
    await _saveTranscriptions();
    notifyListeners();
  }

  // Save transcriptions to SharedPreferences
  Future<void> _saveTranscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _transcriptions.map((e) => e.toJson()).toList();
    await prefs.setString('transcriptions', jsonEncode(jsonList));
  }
}
