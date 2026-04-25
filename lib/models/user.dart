class User {
  final int id;
  final String name;
  final String email;
  final String? bio;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
    );
  }
}
