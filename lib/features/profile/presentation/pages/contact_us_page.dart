import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.contactUs,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header / Brand ─────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.fieldBorder, width: 1.5),
                    ),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 80.r,
                      height: 80.r,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.storeName,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'We are always here to help you.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48.h),

            // ── Store Contacts ─────────────────────
            Text(
              l10n.storeContacts,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            _ContactCard(
              icon: Icons.phone_rounded,
              title: l10n.callUs,
              subtitle: '+213 555 123 456',
              onTap: () => _launchUrl('tel:+213555123456'),
            ),
            SizedBox(height: 12.h),
            _ContactCard(
              icon: Icons.location_on_rounded,
              title: l10n.location,
              subtitle: '123 Market Street, Algiers',
              onTap: () => _launchUrl('https://maps.google.com/?q=36.752887,3.042048'),
            ),

            SizedBox(height: 40.h),

            // ── Developer Contacts ──────────────────
            Text(
              l10n.developerContacts,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            _ContactCard(
              icon: Icons.facebook_rounded,
              title: 'Facebook',
              subtitle: '@developer_name',
              onTap: () => _launchUrl('https://facebook.com/developer_name'),
            ),
            SizedBox(height: 12.h),
            _ContactCard(
              icon: Icons.work_rounded, // Stand-in for LinkedIn
              title: 'LinkedIn',
              subtitle: 'linkedin.com/in/developer',
              onTap: () => _launchUrl('https://linkedin.com/in/developer'),
            ),
            SizedBox(height: 12.h),
            _ContactCard(
              icon: Icons.code_rounded, // Stand-in for GitHub
              title: 'GitHub',
              subtitle: 'github.com/developer',
              onTap: () => _launchUrl('https://github.com/developer'),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24.r),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16.r, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
