class Transcription {
  final String id;
  final String name;
  final String text;

  Transcription({required this.id, required this.name, required this.text});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed',
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'text': text,
    };
  }
}
