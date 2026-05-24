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
  final String id;
  final String title;
  final String content;
  final String category;
  final String? source;
  final String? imageUrl;

  EducationContent({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    String? source,
    this.imageUrl,
  }) : source = source ?? _defaultSourceFor(category);

  factory EducationContent.fromJson(Map<String, dynamic> json) {
    return EducationContent(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
      source: json['source'] ?? json['sumber'],
      imageUrl: json['imageUrl'] ?? json['image_url'],
    );
  }

  static String? _defaultSourceFor(String category) {
    switch (category.toLowerCase()) {
      case 'mengenal tbc':
      case 'pengenalan tbc':
      case 'gejala':
      case 'gejala & deteksi':
        return 'https://tbindonesia.or.id/';
      case 'penularan':
        return 'https://www.who.int/health-topics/tuberculosis';
      case 'pencegahan':
      case 'etika batuk':
        return 'https://bphn.go.id/data/documents/16pmkes067.pdf';
      case 'obat-obatan oat':
      case 'pengobatan':
      case 'tbc resistan':
        return 'https://www.tbindonesia.or.id/wp-content/uploads/2021/06/NSP-TB-2020-2024-Ind_Final_-BAHASA.pdf';
      case 'nutrisi':
        return 'https://www.who.int/health-topics/tuberculosis';
    }
    return null;
  }
}
