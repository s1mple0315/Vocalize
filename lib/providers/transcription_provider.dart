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
 void addTranscription(String name, String text) {
    final newTranscription = Transcription(
      id: DateTime.now().toIso8601String(), // Generate a unique ID
      name: name,
      text: text,
    );
    _transcriptions.add(newTranscription);
    notifyListeners();
  }

  // Save transcriptions to SharedPreferences
  Future<void> _saveTranscriptions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _transcriptions.map((e) => e.toJson()).toList();
    await prefs.setString('transcriptions', jsonEncode(jsonList));
  }

  // Update an existing transcription
  void updateTranscription(String id, String updatedText) {
    final index = _transcriptions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transcriptions[index] = Transcription(
        id: _transcriptions[index].id,
        name: _transcriptions[index].name,
        text: updatedText,
      );
      notifyListeners();
    }
  }

  // Delete a transcription
  Future<void> deleteTranscription(String id) async {
    _transcriptions.removeWhere((t) => t.id == id);
    await _saveTranscriptions();
    notifyListeners();
  }
}