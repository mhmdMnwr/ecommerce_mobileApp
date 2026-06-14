import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final num price;
  final String image;
  final int? units;
  final String? state;
  final Map<String, dynamic>? brand;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.units,
    this.state,
    this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
