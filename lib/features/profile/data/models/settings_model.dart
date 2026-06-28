class SettingsModel {
  final double minOrderAmount;
  final String shopPhone;
  final double? shopLatitude;
  final double? shopLongitude;
  final String developerName;
  final String developerGithub;
  final String developerLinkedIn;
  final String developerEmail;
  final String developerFacebook;

  SettingsModel({
    required this.minOrderAmount,
    required this.shopPhone,
    this.shopLatitude,
    this.shopLongitude,
    required this.developerName,
    required this.developerGithub,
    required this.developerLinkedIn,
    required this.developerEmail,
    required this.developerFacebook,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      minOrderAmount: (json['minOrderAmount'] as num?)?.toDouble() ?? 50000.0,
      shopPhone: json['shopPhone'] as String? ?? '',
      shopLatitude: (json['shopLatitude'] as num?)?.toDouble(),
      shopLongitude: (json['shopLongitude'] as num?)?.toDouble(),
      developerName: json['developerName'] as String? ?? '',
      developerGithub: json['developerGithub'] as String? ?? '',
      developerLinkedIn: json['developerLinkedIn'] as String? ?? '',
      developerEmail: json['developerEmail'] as String? ?? '',
      developerFacebook: json['developerFacebook'] as String? ?? '',
    );
  }
}
