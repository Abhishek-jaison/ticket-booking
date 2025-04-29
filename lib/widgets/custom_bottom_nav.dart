import 'package:flutter/material.dart';
import 'package:event_ticket/theme/app_theme.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  double _previousPosition = 0;
  double _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: _previousPosition,
      end: _currentPosition,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousPosition = _currentPosition;
      _currentPosition = widget.currentIndex.toDouble();
      _slideAnimation = Tween<double>(
        begin: _previousPosition,
        end: _currentPosition,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width - 48; // Account for padding
    final itemWidth = screenWidth / 4; // Divide by number of items

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                final position = _slideAnimation.value * itemWidth;
                return Positioned(
                  left: position + (itemWidth - 40) / 2,
                  top: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.neonYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            // Navigation items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context,
                    icon: Icons.home_rounded, index: 0, width: itemWidth),
                _buildNavItem(context,
                    icon: Icons.event_rounded, index: 1, width: itemWidth),
                _buildNavItem(context,
                    icon: Icons.trending_up_rounded,
                    index: 2,
                    width: itemWidth),
                _buildNavItem(context,
                    icon: Icons.person_rounded, index: 3, width: itemWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    required double width,
  }) {
    final isSelected = widget.currentIndex == index;

    return SizedBox(
      width: width,
      height: 64,
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Icon(
            icon,
            color: isSelected ? Colors.black : const Color(0xFF1E1E1E),
            size: 24,
          ),
        ),
      ),
    );
  }
}
