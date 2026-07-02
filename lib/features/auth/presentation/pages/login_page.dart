import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/utils/auth_message_translator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/di/injection_container.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../../../profile/presentation/widgets/language_dialog.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

import '../../../../core/services/version_service.dart';
import '../../../splash/presentation/pages/update_required_screen.dart';

/// Login screen handling both the initial Splash Sequence and Authentication.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  late final AnimationController _splashCtrl;

  @override
  void initState() {
    super.initState();
    _splashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _runSplashSequence();
  }

  Future<void> _runSplashSequence() async {
    if (kIsWeb) {
      if (mounted) {
        context.read<AuthCubit>().checkAuthStatus();
      }
      _splashCtrl.value = 1.0; // Instantly show form

      // Hold briefly to allow auth status to settle if it was synchronous
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        sl<NotificationCubit>().startPolling();
        context.go(AppRoutes.home);
        return;
      }
      if (authState is AuthPendingApproval) {
        context.go(AppRoutes.pendingApproval);
        return;
      }
      return;
    }

    // Stage 1: Icon is centered. Allow native splash to transition and Flutter engine to settle.
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (mounted) {
      bool versionCheckSuccess = false;
      while (!versionCheckSuccess && mounted) {
        final updateResult = await VersionService.checkForUpdate();
        if (!mounted) return;
        
        if (updateResult.hasError) {
          final retry = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Connection Error'),
              content: const Text('Failed to verify app version. Please check your internet connection and try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
          if (retry != true) return;
          continue;
        }
        
        versionCheckSuccess = true;
        if (updateResult.updateRequired && updateResult.info != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => UpdateRequiredScreen(versionInfo: updateResult.info!),
            ),
          );
          return;
        }
      }
    }

    // Check Auth Status concurrently.
    if (mounted) {
      context.read<AuthCubit>().checkAuthStatus();
    }

    // Stage 1: Icon is centered. Allow native splash to transition and Flutter engine to settle.
    // This also gives the local token check time to complete.
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    final initialState = context.read<AuthCubit>().state;

    if (initialState is AuthUnauthenticated) {
      // No token found. Animate perfectly smoothly to show the form in one continuous motion.
      await _splashCtrl.animateTo(
        1.0, 
        duration: const Duration(milliseconds: 800), 
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Token found, verifying with server. Animate logo to center and hold.
      await _splashCtrl.animateTo(
        0.4, 
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOutCubic,
      );
      
      // Wait until the server responds
      while (mounted && context.read<AuthCubit>().state is AuthLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      
      if (!mounted) return;
      final finalState = context.read<AuthCubit>().state;
      
      if (finalState is AuthAuthenticated) {
        sl<NotificationCubit>().startPolling();
        context.go(AppRoutes.home);
      } else if (finalState is AuthPendingApproval) {
        context.go(AppRoutes.pendingApproval);
      } else {
        // Token was expired or invalid. Show the login form.
        await _splashCtrl.animateTo(
          1.0, 
          duration: const Duration(milliseconds: 450), 
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _splashCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    print("DEBUG: _onLogin button tapped!");
    if (!_formKey.currentState!.validate()) {
      print("DEBUG: Form validation failed.");
      return;
    }
    print("DEBUG: Form valid, calling AuthCubit.login...");
    context.read<AuthCubit>().login(
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  Widget _buildAnimatedLogo() {
    // Increased size to 280.w as requested ("make the logo on the login screen bigger")
    final double rawLogoWidth = 280.w;
    final double logoWidth = rawLogoWidth > 0 ? rawLogoWidth : 280.0;
    final double scale = logoWidth / 584;
    final double logoHeight = 147 * scale;
    final double iconWidth = 168 * scale;

    final double baseFactor = logoWidth > 0 ? iconWidth / logoWidth : 0.0;

    return AnimatedBuilder(
      animation: _splashCtrl,
      builder: (context, child) {
        // slideProgress: 0.0 -> 1.0 during controller 0.0 -> 0.4
        final slideProgress = (_splashCtrl.value / 0.4).clamp(0.0, 1.0);
        
        double currentWidthFactor = baseFactor + ((1.0 - baseFactor) * slideProgress);
        if (currentWidthFactor.isNaN || currentWidthFactor < 0.0) {
          currentWidthFactor = 0.0;
        }

        final initialXOffset = (logoWidth / 2) - (iconWidth / 2);
        final currentXOffset = initialXOffset * (1.0 - slideProgress);

        return Transform.translate(
          offset: Offset(currentXOffset, 0),
          child: SizedBox(
            width: logoWidth,
            height: logoHeight,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: currentWidthFactor,
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      width: logoWidth,
                      height: logoHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/app_icon.png',
                  width: iconWidth,
                  height: logoHeight,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated && (kIsWeb || _splashCtrl.isCompleted)) {
            sl<NotificationCubit>().startPolling();
            context.go(AppRoutes.home);
          } else if (state is AuthPendingApproval) {
            context.go(AppRoutes.pendingApproval);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(translateAuthMessage(context, state.message)),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ));
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAnimatedLogo(),
                      
                      // This SizeTransition handles pushing the logo UP as the form appears
                      AnimatedBuilder(
                        animation: _splashCtrl,
                        builder: (context, child) {
                          // formProgress: 0.0 -> 1.0 during controller 0.4 -> 1.0
                          final formProgress = ((_splashCtrl.value - 0.4) / 0.6).clamp(0.0, 1.0);
                          
                          return SizeTransition(
                            sizeFactor: AlwaysStoppedAnimation(formProgress),
                            axisAlignment: -1.0, // Reveal top-down
                            child: FadeTransition(
                              opacity: AlwaysStoppedAnimation(formProgress),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 48.h),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.logIn,
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 32.h),
                                  AppTextField(
                                    controller: _usernameCtrl,
                                    hintText: AppLocalizations.of(context)!.username,
                                    validator: (v) => Validators.username(context, v),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  SizedBox(height: 14.h),
                                  AppTextField(
                                    controller: _passwordCtrl,
                                    hintText: AppLocalizations.of(context)!.password,
                                    obscureText: _obscure,
                                    validator: (v) => Validators.password(context, v),
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _onLogin(),
                                    suffixIcon: GestureDetector(
                                      onTap: () => setState(() => _obscure = !_obscure),
                                      child: Icon(
                                        _obscure
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColors.textHint,
                                        size: 20.r,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32.h),
                                  BlocBuilder<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      return AppButton(
                                        text: AppLocalizations.of(context)!.logIn,
                                        isLoading: state is AuthLoading,
                                        onPressed: _onLogin,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 28.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.dontHaveAccount,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      GestureDetector(
                                        onTap: () => context.go(AppRoutes.register),
                                        child: Text(
                                          AppLocalizations.of(context)!.signUp,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16.h,
                right: 16.w,
                child: AnimatedBuilder(
                  animation: _splashCtrl,
                  builder: (context, child) {
                    final formProgress = ((_splashCtrl.value - 0.4) / 0.6).clamp(0.0, 1.0);
                    return FadeTransition(
                      opacity: AlwaysStoppedAnimation(formProgress),
                      child: child,
                    );
                  },
                  child: IconButton(
                    icon: Icon(Icons.language, color: AppColors.textPrimary, size: 28.r),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => LanguageDialog(localeCubit: sl<LocaleCubit>()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
