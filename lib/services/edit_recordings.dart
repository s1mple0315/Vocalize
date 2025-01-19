import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EditRecordingsService {
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

  Future<List<File>> getRecordings() async {
    final Directory directory = await _getTargetDirectory();

    if (!await directory.exists()) {
      return [];
    }

    final List<FileSystemEntity> entities = directory.listSync();

    return entities
        .where((entity) => entity is File && entity.path.endsWith('.wav'))
        .cast<File>()
        .toList();
  }

  Future<void> deleteRecording(File file) async {
    if (await file.exists()) {
      await file.delete();
    } else {
      throw Exception('File does not exist: ${file.path}');
    }
  }

  Future<File> renameRecording(File file, String newName) async {
    if (!await file.exists()) {
      throw Exception('File does not exist: ${file.path}');
    }

    final Directory directory = file.parent;
    final String newPath = '${directory.path}/$newName.wav';

    if (await File(newPath).exists()) {
      throw Exception('A file with the name $newName already exists');
    }

    return file.rename(newPath);
  }
}
