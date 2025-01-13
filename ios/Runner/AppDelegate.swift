import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let whisperChannel = FlutterMethodChannel(name: "whisper", binaryMessenger: controller.binaryMessenger)
        whisperChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "transcribe" {
                if let args = call.arguments as? [String: Any], let filePath = args["filePath"] as? String {
                    self.transcribeAudio(filePath: filePath, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "File path not provided", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func transcribeAudio(filePath: String, result: @escaping FlutterResult) {
        guard let url = URL(string: filePath) else {
            result(FlutterError(code: "INVALID_URL", message: "Invalid file URL", details: nil))
            return
        }

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/audio/transcriptions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()

        // Add audio file data
        let fileName = url.lastPathComponent
        let fileData = try? Data(contentsOf: url)
        if let fileData = fileData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        // Add model parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body as Data

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                result(FlutterError(code: "REQUEST_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                result(FlutterError(code: "INVALID_RESPONSE", message: "Unexpected status code \(httpResponse.statusCode)", details: nil))
                return
            }

            if let data = data {
                result(String(data: data, encoding: .utf8))
            } else {
                result(FlutterError(code: "NO_DATA", message: "No data received", details: nil))
            }
        }

        task.resume()
    }
}