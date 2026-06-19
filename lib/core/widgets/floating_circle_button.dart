import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Reusable floating circular icon button (used on product page, etc.).
class FloatingCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const FloatingCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: AppColors.background.withAlpha(230),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 18.r, color: AppColors.textPrimary),
      ),
    );
  }
}
