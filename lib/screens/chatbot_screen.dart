import 'package:flutter/material.dart';
import '../theme.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Today, 10:42 AM',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBotMessage(
                  'Halo! Saya Aura AI Assistant. Ada yang bisa saya bantu tentang kesehatan Anda hari ini?',
                ),
                const SizedBox(height: 16),
                _buildUserMessage('Apa saja gejala TBC?'),
                const SizedBox(height: 16),
                _buildBotMessage(
                  'Gejala umum Tuberculosis (TBC) yang perlu diwaspadai meliputi:\n\n• Batuk yang berlangsung lebih dari 2 minggu (bisa disertai darah)\n• Sesak napas dan nyeri di area dada\n• Berkeringat di malam hari tanpa aktivitas fisik\n• Penurunan berat badan dan nafsu makan yang drastis',
                ),
              ],
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
                      _buildChip('Lokasi RS'),
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
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan Anda...',
                          prefixIcon: const Icon(Icons.attach_file),
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
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      backgroundColor: AppTheme.primaryColor,
                      radius: 24,
                      child: const Icon(Icons.send, color: Colors.white),
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
        CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
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
        const SizedBox(width: 48), // Padding on right
      ],
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 48), // Padding on left
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
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }
}
