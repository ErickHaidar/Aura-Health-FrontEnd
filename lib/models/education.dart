class EducationCategory {
  final String name;
  final String? description;

  EducationCategory({required this.name, this.description});

  factory EducationCategory.fromJson(Map<String, dynamic> json) {
    return EducationCategory(
      name: json['name'] ?? json['category'] ?? '',
      description: json['description'],
    );
  }
}

class EducationContent {
  final int id;
  final String title;
  final String content;
  final String category;
  final String? imageUrl;

  EducationContent({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imageUrl,
  });

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
    );
  }
}
