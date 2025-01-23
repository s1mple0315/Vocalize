import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalize/models/transcription_model.dart';
import 'package:uuid/uuid.dart';

class TranscriptionProvider with ChangeNotifier {
  final Uuid _uuid = Uuid(); // For generating unique IDs
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
    final newTranscription = Transcription(
      id: _uuid.v4(), // Generate a unique ID for each transcription
      name: name,
      text: text,
    );
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

  // Update an existing transcription
  Future<void> updateTranscription(String id, String newText) async {
    final index = _transcriptions.indexWhere((t) => t.id == id);
    if (index != -1) {
      _transcriptions[index] = Transcription(
        id: _transcriptions[index].id,
        name: _transcriptions[index].name,
        text: newText,
      );
      await _saveTranscriptions();
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