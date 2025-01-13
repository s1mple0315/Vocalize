package com.arassanusga.vocalize

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "whisper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "transcribe") {
                val apiKey = call.argument<String>("apiKey")
                val filePath = call.argument<String>("filePath")
                transcribeAudio(apiKey!!, filePath!!, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun transcribeAudio(apiKey: String, filePath: String, result: MethodChannel.Result) {
        val file = File(filePath)
        val requestBody = MultipartBody.Builder()
            .setType(MultipartBody.FORM)
            .addFormDataPart("file", file.name, RequestBody.create(MediaType.parse("audio/mpeg"), file))
            .addFormDataPart("model", "whisper-1")
            .build()

        val request = Request.Builder()
            .url("https://api.openai.com/v1/audio/transcriptions")
            .post(requestBody)
            .addHeader("Authorization", "Bearer $apiKey")
            .build()

        OkHttpClient().newCall(request).execute().use { response ->
            if (!response.isSuccessful) throw IOException("Unexpected code $response")

            val responseBody = response.body?.string()
            result.success(responseBody)
        }
    }
}