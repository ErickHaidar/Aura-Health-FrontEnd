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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'createdAt': createdAt,
    };
  }

  Post copyWith({
    int? id,
    String? content,
    String? imageUrl,
    String? authorName,
    String? authorAvatar,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    String? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Comment {
  final int id;
  final String comment;
  final String authorName;
  final String? authorAvatar;
  final bool isLiked;
  final int likesCount;
  final String? createdAt;

  Comment({
    required this.id,
    required this.comment,
    required this.authorName,
    this.authorAvatar,
    this.isLiked = false,
    this.likesCount = 0,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Comment(
      id: json['id'] ?? 0,
      comment: json['comment'] ?? '',
      authorName: user?['name'] ?? json['authorName'] ?? 'Anonim',
      authorAvatar: user?['avatarUrl'] ?? user?['avatar_url'],
      isLiked: json['isLiked'] ?? json['is_liked'] ?? false,
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'isLiked': isLiked,
      'likesCount': likesCount,
      'createdAt': createdAt,
    };
  }

  Comment copyWith({
    int? id,
    String? comment,
    String? authorName,
    String? authorAvatar,
    bool? isLiked,
    int? likesCount,
    String? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

