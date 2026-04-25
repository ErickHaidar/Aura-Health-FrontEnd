class Article {
  final int id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String? createdAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }
}
