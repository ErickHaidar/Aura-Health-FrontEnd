import 'package:flutter/material.dart';

class PostSkeleton extends StatefulWidget {
  const PostSkeleton({super.key});

  @override
  State<PostSkeleton> createState() => _PostSkeletonState();
}

class _PostSkeletonState extends State<PostSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: Colors.grey[200],
      end: Colors.grey[300],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBox({required double width, required double height}) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: _colorAnimation.value,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBox(width: 150, height: 16),
                    const SizedBox(height: 8),
                    _buildBox(width: 100, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBox(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            _buildBox(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            _buildBox(width: 200, height: 14),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildBox(width: 60, height: 24),
                const SizedBox(width: 16),
                _buildBox(width: 60, height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
