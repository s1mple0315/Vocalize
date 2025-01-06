import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _recorder.openRecorder();
      _isInitialized = true;
    }
  }

  Future<void> startRecording() async {
    if (!await Permission.microphone.request().isGranted) {
      throw Exception('Microphone permission denied');
    }

    if (Platform.isAndroid && !await Permission.storage.request().isGranted) {
      throw Exception('Storage permission denied');
    }

    final Directory directory = await _getTargetDirectory();

    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final String path =
        '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: path);
    print('Recording started: $path');
  }

  Future<String?> stopRecording() async {
    final String? path = await _recorder.stopRecorder();
    print('Recording stopped: $path');
    return path;
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
  }

  Future<Directory> _getTargetDirectory() async {
    if (Platform.isAndroid) {
      final Directory downloadsDir = Directory('/storage/emulated/0/Download');
      return Directory('${downloadsDir.path}/Vocalize');
    } else if (Platform.isIOS) {
      final Directory documentsDir = await getApplicationDocumentsDirectory();
      return Directory('${documentsDir.path}/Vocalize');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<List<File>> listRecordings() async {
    final Directory directory = await _getTargetDirectory();

    if (!await directory.exists()) {
      return [];
    }

    final List<FileSystemEntity> entities = directory.listSync();

    final List<File> audioFiles = entities
        .where((entity) => entity is File && entity.path.endsWith('.aac'))
        .cast<File>()
        .toList();

    return audioFiles;
  }
}
