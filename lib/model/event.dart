class Event {
  int? id;
  String namaEvent;
  String description;
  String linkEvent;
  String imagePath;
  String? imageAssetPath;

  Event({
    this.id,
    required this.namaEvent,
    required this.description,
    required this.linkEvent,
    required this.imagePath,
    this.imageAssetPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaEvent': namaEvent,
      'description': description,
      'linkEvent': linkEvent,
      'imagePath': imagePath,
      'imageAssetPath': imageAssetPath,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      namaEvent: json['namaEvent'],
      description: json['description'],
      linkEvent: json['linkEvent'],
      imagePath: json['imagePath'],
      imageAssetPath: json['imageAssetPath'],
    );
  }
}
