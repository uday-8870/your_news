class Post {
  final int? id; // Made nullable
  final String title;
  final String content;
  final String? imageUrl; // Made nullable
  final String? createdAt; // Made nullable

  Post({this.id, required this.title, required this.content, this.imageUrl, this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int?, // Cast as nullable int
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?, // Corrected key from 'image_url' to 'imageUrl' and made nullable
      createdAt: json['created_at'] as String?, // Made nullable
    );
  }
}