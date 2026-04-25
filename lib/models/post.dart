class Post {
  final int id;
  final String content;
  final String? imageUrl;
  final String authorName;
  final String? authorAvatar;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final String? createdAt;

  Post({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.authorName,
    this.authorAvatar,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Post(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      authorName: user?['name'] ?? json['authorName'] ?? 'Anonim',
      authorAvatar: user?['avatarUrl'] ?? user?['avatar_url'],
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['comments_count'] ?? 0,
      isLiked: json['isLiked'] ?? json['is_liked'] ?? false,
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }
}

class Comment {
  final int id;
  final String comment;
  final String authorName;
  final String? authorAvatar;
  final String? createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.authorName,
    this.authorAvatar,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Comment(
      id: json['id'] ?? 0,
      comment: json['comment'] ?? '',
      authorName: user?['name'] ?? json['authorName'] ?? 'Anonim',
      authorAvatar: user?['avatarUrl'] ?? user?['avatar_url'],
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }
}
