import 'package:flutter/material.dart';
import 'package:vocalize/models/transcription_model.dart';

class TranscriptionProvider with ChangeNotifier{
  List<Transcription> _transcriptions = [];

  List<Transcription> get transcriptions => _transcriptions;

  void addTranscription(String name, String text) {
    _transcriptions.add(Transcription(name: name, text: text));
    notifyListeners();
  }
}