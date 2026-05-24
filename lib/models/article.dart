class Article {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;
  final String? createdAt;
  final String? author;
  final String? summary;
  final bool isLiked;
  final int likesCount;
  final String? sourceUrl;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
    this.createdAt,
    this.author,
    this.summary,
    this.isLiked = false,
    this.likesCount = 0,
    this.sourceUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      createdAt: json['createdAt'] ?? json['created_at'],
      author: json['author'],
      summary: json['summary'] ?? json['excerpt'],
      isLiked: json['isLiked'] ?? json['is_liked'] ?? false,
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      sourceUrl: json['sourceUrl'] ?? json['source_url'] ?? json['url'],
    );
  }

  Article copyWith({
    bool? isLiked,
    int? likesCount,
  }) {
    return Article(
      id: id,
      title: title,
      content: content,
      category: category,
      imageUrl: imageUrl,
      createdAt: createdAt,
      author: author,
      summary: summary,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      sourceUrl: sourceUrl,
    );
  }
}
