import 'package:flutter/material.dart';
import 'package:event_ticket/theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
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
            // Background with split colors
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: currentIndex == 0
                          ? AppTheme.neonYellow
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: currentIndex == 1
                          ? AppTheme.neonYellow
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Navigation items
            Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.person_rounded,
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                ),
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
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Icon(
          icon,
          color: isSelected ? Colors.black : const Color(0xFF1E1E1E),
          size: 24,
        ),
      ),
    );
  }
}
