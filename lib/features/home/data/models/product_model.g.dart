// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['_id'] as String,
  title: json['title'] as String,
  price: json['price'] as num,
  image: json['image'] as String,
  units: (json['units'] as num?)?.toInt(),
  state: json['state'] as String?,
  brand: json['brand'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'image': instance.image,
      'units': instance.units,
      'state': instance.state,
      'brand': instance.brand,
    };
