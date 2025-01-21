import 'package:flutter/material.dart';
import 'package:vocalize/providers/transcription_provider.dart';
import 'package:vocalize/ui/pages/main_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final transcriptionProvider = TranscriptionProvider();
  await transcriptionProvider.loadTranscriptions();

  runApp(
    ChangeNotifierProvider(
      create: (context) => transcriptionProvider,
      child: const VocalizeApp(),
    ),
  );
}

class VocalizeApp extends StatelessWidget {
  const VocalizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vocalize',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        primarySwatch: Colors.grey,
      ),
      home: const MainPage(),
    );
  }
}
