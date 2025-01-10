import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vocalize/services/edit_recordings.dart';

class RecordingsPage extends StatefulWidget {
  const RecordingsPage({Key? key}) : super(key: key);

  @override
  _RecordingsPageState createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  final EditRecordingsService _recordingsService = EditRecordingsService();
  List<File> _recordings = [];

  @override
  void initState() {
    super.initState();
    _fetchRecordings();
  }

  Future<void> _fetchRecordings() async {
    final List<File> recordings = await _recordingsService.getRecordings();
    setState(() {
      _recordings = recordings;
    });
  }

  Future<void> _deleteRecording(File file) async {
    try {
      await _recordingsService.deleteRecording(file);
      _fetchRecordings(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording deleted')),
      );
    } catch (e) {
      _showErrorDialog('Error deleting recording', e.toString());
    }
  }

  Future<void> _renameRecording(File file) async {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Rename Recording', style: TextStyle(color: Colors.white),),
        content: TextField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                if (controller.text.trim().isNotEmpty) {
                  await _recordingsService.renameRecording(file, controller.text.trim());
                  _fetchRecordings(); // Refresh the list
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recording renamed')),
                  );
                }
              } catch (e) {
                _showErrorDialog('Error renaming recording', e.toString());
              }
            },
            child: const Text('Rename'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCommandMenu(BuildContext context, File recording) {
    showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow, color: Colors.white,),
            title: const Text('Play', style: TextStyle(color: Colors.white),),
            onTap: () {
              // Play logic here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white,),
            title: const Text('Rename', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.pop(context);
              _renameRecording(recording);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.white,),
            title: const Text('Delete', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.pop(context);
              _deleteRecording(recording);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Recordings',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'refresh') {
                _fetchRecordings();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Text('Refresh'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: _recordings.isEmpty
          ? const Center(
              child: Text(
                'No recordings found',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.separated(
              itemCount: _recordings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final File recording = _recordings[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[900],
                  ),
                  child: ListTile(
                    title: Text(
                      recording.path.split('/').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () => _showCommandMenu(context, recording),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
