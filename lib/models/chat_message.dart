class ChatMessage {
  final String message;
  final String? response;
  final bool isUser;
  final String? createdAt;

  ChatMessage({
    required this.message,
    this.response,
    required this.isUser,
    this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      response: json['response'],
      isUser: json['isUser'] ?? true,
      createdAt: json['createdAt'] ?? json['created_at'],
    );
  }
}
