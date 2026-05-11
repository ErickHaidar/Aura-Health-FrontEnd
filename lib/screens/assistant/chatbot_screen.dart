import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../services/chat_service.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import '../../models/chat_message.dart';

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
    try {
      final results = await Future.wait([
        ChatService.getHistory(),
        UserService.getMyProfile(),
      ]);

      final historyResult = results[0];
      final userResult = results[1];

      if (!mounted) return;

      setState(() {
        if (userResult['success'] == true) {
          _user = userResult['user'] as User;
        }

        if (historyResult['success'] == true) {
          final messages = historyResult['messages'] as List<ChatMessage>;
          for (final msg in messages) {
            _messages.add({
              'role': 'user',
              'text': msg.message,
              'type': 'normal',
              'time': msg.createdAt ?? '',
            });
            if (msg.response != null && msg.response!.isNotEmpty) {
              _messages.add({
                'role': 'bot',
                'text': msg.response!,
                'type': 'normal',
                'time': msg.createdAt ?? '',
              });
            }
          }
        }

        if (_messages.isEmpty) {
          _messages.add({
            'role': 'bot',
            'text': 'Halo! Saya Asisten AI Aura. Ada yang bisa saya bantu tentang kesehatan Anda hari ini?',
            'type': 'normal',
            'time': DateTime.now().toIso8601String(),
          });
        }
        _isLoadingHistory = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Halo! Saya Asisten AI Aura. Ada yang bisa saya bantu tentang kesehatan Anda hari ini?',
          'type': 'normal',
          'time': DateTime.now().toIso8601String(),
        });
        _isLoadingHistory = false;
      });
    }

    _scrollToBottom(delayed: true);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final now = DateTime.now().toIso8601String();
    setState(() {
      _messages.add({'role': 'user', 'text': text.trim(), 'type': 'normal', 'time': now});
      _isSending = true;
    });
    _messageController.clear();
    _scrollToBottom();

    final result = await ChatService.sendMessage(text.trim());

    if (!mounted) return;

    final replyTime = DateTime.now().toIso8601String();
    setState(() {
      if (result['success'] == true) {
        _messages.add({
          'role': 'bot',
          'text': result['message'] ?? 'Maaf, saya tidak bisa menjawab saat ini.',
          'type': 'normal',
          'time': replyTime,
        });
      } else {
        _messages.add({'role': 'bot', 'text': 'Error', 'type': 'error', 'time': replyTime});
      }
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom({bool delayed = false}) {
    if (delayed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } else {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Asisten AI Aura',
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
                  'AKTIF',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingHistory
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final time = msg['time'] ?? '';
                      if (msg['role'] == 'user') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildUserMessage(msg['text']!, time: time),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildBotMessage(
                            msg['text']!,
                            isError: msg['type'] == 'error',
                            time: time,
                          ),
                        );
                      }
                    },
                  ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                            fillColor:
                                Theme.of(context).cardColor == Colors.white
                                ? Colors.grey.shade100
                                : Colors.grey.shade800,
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
          ),
        ],
      ),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(dt.year, dt.month, dt.day);
      final hm = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      if (msgDay == today) return hm;
      final diff = today.difference(msgDay).inDays;
      if (diff == 1) return 'Kemarin $hm';
      return '${dt.day}/${dt.month}/${dt.year} $hm';
    } catch (_) {
      return '';
    }
  }

  Widget _buildBotMessage(String text, {bool isError = false, String time = ''}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isError ? Colors.red.shade50 : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isError ? Colors.red.shade300 : Colors.grey.shade200,
                  ),
                ),
                child: isError
                    ? Text(
                        text,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : _buildFormattedBotText(text),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    _formatTime(time),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildFormattedBotText(String text) {
    final spans = <TextSpan>[];
    final pattern = RegExp(r'\*\*(.*?)\*\*');
    var currentIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1) ?? '',
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          height: 1.45,
        ),
        children: spans,
      ),
    );
  }

  Widget _buildUserMessage(String text, {String time = ''}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _formatTime(time),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: _user?.avatarUrl != null
              ? (_user!.avatarUrl!.startsWith('http')
                    ? CachedNetworkImageProvider(_user!.avatarUrl!) as ImageProvider
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
          color: Theme.of(context).cardColor == Colors.white
              ? Colors.grey.shade100
              : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
    );
  }
}
