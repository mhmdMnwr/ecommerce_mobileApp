import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// Shows a success popup with a checkmark icon and a message.
///
/// Auto-dismisses after [autoDismissMs] milliseconds (default 2000).
///
/// Usage:
/// ```dart
/// AppSuccessDialog.show(context, message: 'Order placed!');
/// ```
class AppSuccessDialog {
  AppSuccessDialog._();

  /// Shows the success overlay.
  static void show(
    BuildContext context, {
    String? message,
    int autoDismissMs = 2000,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (_) => _SuccessContent(message: message),
    );

    // Auto-dismiss after duration
    Future.delayed(Duration(milliseconds: autoDismissMs), () {
      if (context.mounted) {
        final nav = Navigator.of(context, rootNavigator: true);
        if (nav.canPop()) nav.pop();
      }
    });
  }
}

class _SuccessContent extends StatefulWidget {
  final String? message;
  const _SuccessContent({this.message});

  @override
  State<_SuccessContent> createState() => _SuccessContentState();
}

class _SuccessContentState extends State<_SuccessContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 60.w),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkmark icon matching the design
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withAlpha(15),
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 32.r,
                    color: AppColors.primary,
                  ),
                ),
                if (widget.message != null) ...[
                  SizedBox(height: 18.h),
                  Text(
                    widget.message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBody,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
