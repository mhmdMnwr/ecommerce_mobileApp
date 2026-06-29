import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../../../../core/services/version_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';

class UpdateRequiredScreen extends StatefulWidget {
  final VersionInfo versionInfo;

  const UpdateRequiredScreen({super.key, required this.versionInfo});

  @override
  State<UpdateRequiredScreen> createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  bool _isUpdating = false;

  Future<void> _launchUpdateUrl() async {
    setState(() {
      _isUpdating = true;
    });

    // Provide a brief delay for UX feedback (shows the loading state)
    await Future.delayed(const Duration(milliseconds: 500));

    final url = Uri.parse(widget.versionInfo.downloadUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }

    if (mounted) {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Widget _buildIllustration() {
    return Container(
      width: 140.r,
      height: 140.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withAlpha(15),
      ),
      child: Center(
        child: Container(
          width: 90.r,
          height: 90.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(60),
                blurRadius: 25,
                spreadRadius: 8,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.cloud_sync_rounded,
            size: 44.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIllustration(),
                    SizedBox(height: 56.h),
                    Text(
                      AppLocalizations.of(context)?.updateRequiredTitle ?? 'Update Required',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.updateRequiredDesc ?? 'We have launched a new version of the app to improve your experience.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textBody,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Action Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(
                    color: AppColors.fieldBorder.withAlpha(120),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    text: AppLocalizations.of(context)?.updateNowBtn ?? 'Update Now',
                    isLoading: _isUpdating,
                    onPressed: _launchUpdateUrl,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)?.updateRequiredSubtext ?? 'Update is required to continue using the app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
