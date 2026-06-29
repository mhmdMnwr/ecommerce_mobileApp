import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/constants.dart';

class VersionInfo {
  final int buildNumber;
  final String versionName;
  final String downloadUrl;
  final String? releaseNotes;

  VersionInfo({
    required this.buildNumber,
    required this.versionName,
    required this.downloadUrl,
    this.releaseNotes,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      buildNumber: json['buildNumber'] as int,
      versionName: json['versionName'] as String,
      downloadUrl: json['downloadUrl'] as String,
      releaseNotes: json['releaseNotes'] as String?,
    );
  }
}

class VersionCheckResult {
  final bool updateRequired;
  final VersionInfo? info;
  VersionCheckResult({required this.updateRequired, this.info});
}

class VersionService {
  static Future<VersionCheckResult> checkForUpdate() async {
    try {
      final String platform = Platform.isAndroid ? 'android' : 'ios';
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/app-version?platform=$platform'));
      
      if (response.statusCode != 200) {
        // Non-200 HTTP status
        print('[VersionService] Non-200 status code: ${response.statusCode}');
        return VersionCheckResult(updateRequired: false);
      }

      try {
        final data = jsonDecode(response.body);
        final info = VersionInfo.fromJson(data);
        
        final packageInfo = await PackageInfo.fromPlatform();
        final currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
        
        final isUpdateRequired = currentBuildNumber < info.buildNumber;
        
        return VersionCheckResult(updateRequired: isUpdateRequired, info: info);
      } catch (parseErr) {
        // JSON parse or unexpected shape error
        print('[VersionService] JSON parse error: $parseErr');
        return VersionCheckResult(updateRequired: false);
      }
    } catch (netErr) {
      // Network or timeout error
      print('[VersionService] Network error: $netErr');
      return VersionCheckResult(updateRequired: false);
    }
  }
}
