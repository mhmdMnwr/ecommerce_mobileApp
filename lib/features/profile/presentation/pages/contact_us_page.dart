import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../data/models/settings_model.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  SettingsModel? _settings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    try {
      final response = await sl<ApiClient>().dio.get(ApiConstants.settings);
      if (response.data != null && response.data['data'] != null) {
        setState(() {
          _settings = SettingsModel.fromJson(response.data['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'parse_error';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'load_error';
        _isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String urlString) async {
    if (urlString.isEmpty) return;
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  Future<void> _launchMap(double lat, double lng) async {
    final uri = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final fallbackUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (_error != null) {
      final errorMessage = _error == 'parse_error'
          ? l10n.failedToParseSettings
          : l10n.failedToLoadSettings;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage, style: TextStyle(color: AppColors.error)),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchSettings();
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final settings = _settings!;

    return SingleChildScrollView(
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
                  l10n.weAreHereToHelp,
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
          if (settings.shopPhone.isNotEmpty) ...[
            _ContactCard(
              icon: Icons.phone_rounded,
              title: l10n.callUs,
              subtitle: settings.shopPhone,
              onTap: () => _launchUrl('tel:${settings.shopPhone}'),
            ),
            SizedBox(height: 12.h),
          ],
          if (settings.shopLatitude != null && settings.shopLongitude != null) ...[
            _ContactCard(
              icon: Icons.location_on_rounded,
              title: l10n.location,
              subtitle: l10n.storeLocation,
              onTap: () => _launchMap(settings.shopLatitude!, settings.shopLongitude!),
            ),
            SizedBox(height: 40.h),
          ],

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
          if (settings.developerName.isNotEmpty) ...[
            Text(
              '${l10n.developedBy} ${settings.developerName}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          if (settings.developerFacebook.isNotEmpty) ...[
            _ContactCard(
              icon: Icons.facebook_rounded,
              title: l10n.facebook,
              subtitle: settings.developerFacebook.split('/').last,
              onTap: () => _launchUrl(settings.developerFacebook),
            ),
            SizedBox(height: 12.h),
          ],
          if (settings.developerLinkedIn.isNotEmpty) ...[
            _ContactCard(
              icon: Icons.work_rounded, // Stand-in for LinkedIn
              title: l10n.linkedin,
              subtitle: settings.developerName.isNotEmpty ? settings.developerName : l10n.linkedinProfile,
              onTap: () => _launchUrl(settings.developerLinkedIn),
            ),
            SizedBox(height: 12.h),
          ],
          if (settings.developerGithub.isNotEmpty) ...[
            _ContactCard(
              icon: Icons.code_rounded, // Stand-in for GitHub
              title: l10n.github,
              subtitle: settings.developerGithub.split('/').last,
              onTap: () => _launchUrl(settings.developerGithub),
            ),
            SizedBox(height: 12.h),
          ],
          if (settings.developerEmail.isNotEmpty) ...[
            _ContactCard(
              icon: Icons.email_rounded,
              title: l10n.email,
              subtitle: settings.developerEmail,
              onTap: () => _launchUrl('mailto:${settings.developerEmail}'),
            ),
            SizedBox(height: 40.h),
          ],
        ],
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
