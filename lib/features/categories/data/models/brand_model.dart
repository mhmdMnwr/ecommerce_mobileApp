import 'package:json_annotation/json_annotation.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  @JsonKey(defaultValue: '')
  final String? image;

  const BrandModel({
    required this.id,
    required this.title,
    this.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
}
