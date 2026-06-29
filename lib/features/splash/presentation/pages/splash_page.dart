import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_logo.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import 'dart:io';
import '../../../../core/services/version_service.dart';
import 'update_required_screen.dart';

/// Animated splash screen.
///
/// Shows the full logo (app image + shop name) with a smooth
/// fade-in + scale animation, then navigates to the login page.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Small delay so the screen settles after the native splash.
    await Future.delayed(const Duration(milliseconds: 200));
    _controller.forward();

    // Hold the logo visible, then navigate.
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      if (Platform.isAndroid) {
        final updateResult = await VersionService.checkForUpdate();
        if (!mounted) return;
        
        if (updateResult.updateRequired && updateResult.info != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UpdateRequiredScreen(versionInfo: updateResult.info!),
            ),
          );
          return;
        }
      }

      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppLogo(width: 360.w),
            ),
          ),
        ),
      ),
    );
  }
}
