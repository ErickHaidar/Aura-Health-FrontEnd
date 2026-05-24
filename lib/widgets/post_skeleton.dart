import 'package:flutter/material.dart';

class PostSkeleton extends StatefulWidget {
  const PostSkeleton({super.key});

  @override
  State<PostSkeleton> createState() => _PostSkeletonState();
}

class _PostSkeletonState extends State<PostSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
<<<<<<< HEAD
  late Animation<Color?> _colorAnimation;
=======
  late Animation<double> _animation;
>>>>>>> rizqi0

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
<<<<<<< HEAD
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: Colors.grey[200],
      end: Colors.grey[300],
    ).animate(_controller);
=======
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
>>>>>>> rizqi0
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

<<<<<<< HEAD
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
=======
  Widget _box({double width = double.infinity, double height = 14, double radius = 8}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
>>>>>>> rizqi0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
<<<<<<< HEAD
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
=======
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
>>>>>>> rizqi0
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
<<<<<<< HEAD
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
=======
                _box(width: 40, height: 40, radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 120, height: 12),
                      const SizedBox(height: 6),
                      _box(width: 80, height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _box(height: 12),
            const SizedBox(height: 6),
            _box(height: 12),
            const SizedBox(height: 6),
            _box(width: 200, height: 12),
>>>>>>> rizqi0
          ],
        ),
      ),
    );
  }
}
