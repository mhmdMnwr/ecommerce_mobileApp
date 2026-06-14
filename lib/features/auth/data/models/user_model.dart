import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Data-layer representation of a User returned by the API.
@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String address;
  final String phone;
  final String role;
  final String status;
  final double? latitude;
  final double? longitude;

  const UserModel({
    required this.id,
    required this.username,
    required this.address,
    required this.phone,
    required this.role,
    required this.status,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Creates a copy with the given fields replaced.
  UserModel copyWith({
    String? id,
    String? username,
    String? address,
    String? phone,
    String? role,
    String? status,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
