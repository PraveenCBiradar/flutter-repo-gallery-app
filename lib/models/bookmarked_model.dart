class Bookmark {
  final String imageUrl;
  final String id;

  Bookmark({required this.imageUrl, required this.id});

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      imageUrl: json['imageUrl'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'id': id,
    };
  }
}
