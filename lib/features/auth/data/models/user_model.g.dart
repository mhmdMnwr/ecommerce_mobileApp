// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['_id'] as String,
  username: json['username'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String,
  status: json['status'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  '_id': instance.id,
  'username': instance.username,
  'address': instance.address,
  'phone': instance.phone,
  'role': instance.role,
  'status': instance.status,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
