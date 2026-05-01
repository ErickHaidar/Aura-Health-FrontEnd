import 'package:flutter/material.dart';
import 'dart:io';
import '../theme.dart';
import '../services/chat_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isSending = false;
  bool _isLoadingHistory = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final historyFuture = ChatService.getHistory(limit: 50);
    final userFuture = UserService.getMyProfile();

    final historyResult = await historyFuture;
    final userResult = await userFuture;

    if (!mounted) return;

    setState(() {
      if (userResult['success'] == true) {
        _user = userResult['user'] as User;
      }
      
      if (historyResult['success'] == true) {
        final messages = historyResult['messages'] as List;
        for (final msg in messages) {
          _messages.add({'role': 'user', 'text': msg.message});
          if (msg.response != null) {
            _messages.add({'role': 'bot', 'text': msg.response!});
          }
        }
      }
      // Tambah pesan sambutan jika kosong
      if (_messages.isEmpty) {
        _messages.add({
          'role': 'bot',
          'text': 'Halo! Saya Aura AI Assistant. Ada yang bisa saya bantu tentang kesehatan Anda hari ini?',
        });
      }
      _isLoadingHistory = false;
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text.trim()});
      _isSending = true;
    });
    _messageController.clear();
    _scrollToBottom();

    final result = await ChatService.sendMessage(text.trim());

    if (!mounted) return;

    setState(() {
      if (result['success'] == true) {
        _messages.add({
          'role': 'bot',
          'text': result['message'] ?? 'Maaf, saya tidak bisa menjawab saat ini.',
        });
      } else {
        _messages.add({
          'role': 'bot',
          'text': result['message'] ?? 'Terjadi kesalahan. Coba lagi nanti.',
        });
      }
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Aura AI Assistant',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 8),
                SizedBox(width: 4),
                Text(
                  'ONLINE',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) async {
              if (value == 'clear') {
                final result = await ChatService.clearHistory();
                if (!mounted) return;
                if (result['success'] == true) {
                  setState(() {
                    _messages.clear();
                    _messages.add({
                      'role': 'bot',
                      'text': 'Halo! Saya Aura AI Assistant. Ada yang bisa saya bantu tentang kesehatan Anda hari ini?',
                    });
                  });
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Hapus Riwayat'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingHistory
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isSending ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        // Typing indicator
                        return _buildBotMessage('...');
                      }
                      final msg = _messages[index];
                      if (msg['role'] == 'user') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildUserMessage(msg['text']!),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildBotMessage(msg['text']!),
                        );
                      }
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('Cara Pencegahan'),
                      const SizedBox(width: 8),
                      _buildChip('Gejala TBC'),
                      const SizedBox(width: 8),
                      _buildChip('Obat TBC'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan Anda...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: _isSending ? null : _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _isSending
                          ? null
                          : () => _sendMessage(_messageController.text),
                      child: CircleAvatar(
                        backgroundColor: _isSending
                            ? Colors.grey
                            : AppTheme.primaryColor,
                        radius: 24,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotMessage(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(text),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _user?.avatarUrl != null
              ? (_user!.avatarUrl!.startsWith('http')
                  ? NetworkImage(_user!.avatarUrl!) as ImageProvider
                  : FileImage(File(_user!.avatarUrl!)) as ImageProvider)
              : null,
          child: _user?.avatarUrl == null
              ? const Icon(Icons.person, color: Colors.white, size: 20)
              : null,
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: _isSending ? null : () => _sendMessage(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}
