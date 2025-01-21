class Transcription {
  final String name;
  final String text;

  Transcription({required this.name, required this.text});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      name: json['name'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'text': text,
    };
  }
}
