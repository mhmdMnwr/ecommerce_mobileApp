import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'map_picker_page.dart';

/// Registration screen — username, phone, password, address and/or location.
///
/// At least one of address (typed) or exact location (map pin) is required.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _obscure = true;

  // Map picker result
  double? _latitude;
  double? _longitude;
  String? _locationLabel; // reverse-geocoded display text

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  // ── Map picker ──────────────────────────────────

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );
    if (result != null && mounted) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _locationLabel = result.address;

        // Auto-fill address from geocoding if user hasn't typed one
        if (_addressCtrl.text.trim().isEmpty && result.address != null) {
          _addressCtrl.text = result.address!;
        }
      });
    }
  }

  // ── Submit ──────────────────────────────────────

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    final address = _addressCtrl.text.trim();
    final hasAddress = address.isNotEmpty;
    final hasLocation = _latitude != null && _longitude != null;

    if (!hasAddress && !hasLocation) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: const Text(
              'Please provide an address or select a location on the map'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ));
      return;
    }

    // Always send address if available (typed or geocoded)
    context.read<AuthCubit>().register(
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text.trim(),
          address: hasAddress ? address : null,
          latitude: _latitude,
          longitude: _longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasLocation = _latitude != null && _longitude != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistrationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ));
            context.go(AppRoutes.login);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
              ));
          }
        },
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Title ────────────────────────
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // ── Username ────────────────────
                      AppTextField(
                        controller: _usernameCtrl,
                        hintText: 'Name',
                        validator: Validators.username,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 14.h),

                      // ── Phone ───────────────────────
                      AppTextField(
                        controller: _phoneCtrl,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: Validators.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 14.h),

                      // ── Password ────────────────────
                      AppTextField(
                        controller: _passwordCtrl,
                        hintText: 'Password',
                        obscureText: _obscure,
                        validator: Validators.password,
                        textInputAction: TextInputAction.next,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscure = !_obscure),
                          child: Icon(
                            _obscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textHint,
                            size: 20.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // ── Address (typed) ─────────────
                      AppTextField(
                        controller: _addressCtrl,
                        hintText: 'Delivery address',
                        textInputAction: TextInputAction.done,
                        // not required — validated cross-field in _onRegister
                      ),
                      SizedBox(height: 10.h),

                      // ── "or" divider ────────────────
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: AppColors.fieldBorder)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Divider(color: AppColors.fieldBorder)),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // ── Location picker ─────────────
                      GestureDetector(
                        onTap: _openMapPicker,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.fieldFill,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: hasLocation
                                  ? AppColors.success
                                  : AppColors.fieldBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                hasLocation
                                    ? Icons.check_circle_outline
                                    : Icons.location_searching_rounded,
                                color: hasLocation
                                    ? AppColors.success
                                    : AppColors.textMuted,
                                size: 22.r,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  hasLocation
                                      ? (_locationLabel ??
                                          '📍 Location selected')
                                      : 'Select exact location on map',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: hasLocation
                                        ? AppColors.textPrimary
                                        : AppColors.textHint,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasLocation)
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _latitude = null;
                                    _longitude = null;
                                    _locationLabel = null;
                                  }),
                                  child: Icon(
                                    Icons.close,
                                    size: 18.r,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // ── Register button ─────────────
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return AppButton(
                            text: 'Sign up',
                            isLoading: state is AuthLoading,
                            onPressed: _onRegister,
                          );
                        },
                      ),
                      SizedBox(height: 28.h),

                      // ── Login link ──────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ?',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
