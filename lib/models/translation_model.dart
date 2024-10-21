class Translation {
  final String id;
  final Map<String, String> texts;
  final Map<String, String> audioFiles;

  Translation({
    required this.id,
    required this.texts,
    required this.audioFiles,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      id: json['id'],
      texts: Map<String, String>.from(json['texts']),
      audioFiles: Map<String, String>.from(json['audioFiles']),
    );
  }
}
