import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auth_message_translator.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/location_picker_field.dart';
import '../widgets/register_form_fields.dart';
import 'map_picker_page.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../profile/presentation/widgets/language_dialog.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/di/injection_container.dart';

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

  double? _latitude;
  double? _longitude;
  String? _locationLabel;

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

  Future<void> _openMapPicker() async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );
    if (result != null && mounted) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _locationLabel = result.address;
        if (_addressCtrl.text.trim().isEmpty && result.address != null) {
          _addressCtrl.text = result.address!;
        }
      });
    }
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    final address = _addressCtrl.text.trim();
    final hasAddr = address.isNotEmpty;
    final hasLoc = _latitude != null && _longitude != null;

    if (!hasAddr && !hasLoc) {
      showAppSnackBar(context,
          message: AppLocalizations.of(context)!.pleaseProvideAddress,
          color: AppColors.error);
      return;
    }

    context.read<AuthCubit>().register(
          username: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text.trim(),
          address: hasAddr ? address : null,
          latitude: _latitude,
          longitude: _longitude,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasLocation = _latitude != null && _longitude != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthPendingApproval) {
            context.go(AppRoutes.pendingApproval);
          } else if (state is AuthRegistrationSuccess) {
            showAppSnackBar(context,
                message: translateAuthMessage(context, state.message),
                color: AppColors.success);
            context.go(AppRoutes.login);
          } else if (state is AuthError) {
            showAppSnackBar(context,
                message: translateAuthMessage(context, state.message),
                color: AppColors.error);
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              FadeTransition(
                opacity: _fadeIn,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l10n.signUp,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              )),
                          SizedBox(height: 40.h),
                          RegisterFormFields(
                            usernameCtrl: _usernameCtrl,
                            phoneCtrl: _phoneCtrl,
                            passwordCtrl: _passwordCtrl,
                            addressCtrl: _addressCtrl,
                            obscure: _obscure,
                            onToggleObscure: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          SizedBox(height: 10.h),
                          const OrDivider(),
                          SizedBox(height: 10.h),
                          LocationPickerField(
                            hasLocation: hasLocation,
                            locationLabel: _locationLabel,
                            onTap: _openMapPicker,
                            onClear: () => setState(() {
                              _latitude = null;
                              _longitude = null;
                              _locationLabel = null;
                            }),
                          ),
                          SizedBox(height: 32.h),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) => AppButton(
                              text: l10n.signUp,
                              isLoading: state is AuthLoading,
                              onPressed: _onRegister,
                            ),
                          ),
                          SizedBox(height: 28.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.alreadyHaveAccount,
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary)),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => context.go(AppRoutes.login),
                                child: Text(l10n.logIn,
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.accent)),
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
              Positioned(
                top: 16.h,
                right: 16.w,
                child: FadeTransition(
                  opacity: _fadeIn,
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
