package com.arassanusga.vocalize

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.whisper.transcriber.Whisper // Assuming you implement a Whisper wrapper here

class MainActivity: FlutterActivity() {
    private val CHANNEL = "whisper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "transcribe") {
                val filePath = call.argument<String>("filePath")
                val transcription = WhisperTranscriber().transcribe(filePath) // Create WhisperTranscriber for Android
                result.success(transcription)
            } else {
                result.notImplemented()
            }
        }
    }
}
