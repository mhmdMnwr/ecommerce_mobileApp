// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      productId: json['productId'] as String,
      title: json['title'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      units: (json['units'] as num).toInt(),
      price: json['price'] as num,
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'title': instance.title,
      'quantity': instance.quantity,
      'units': instance.units,
      'price': instance.price,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['_id'] as String,
  customerId: json['customerId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  comment: json['comment'] as String?,
  totalAmount: json['totalAmount'] as num,
  status: json['status'] as String,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'customerId': instance.customerId,
      'items': instance.items,
      'comment': instance.comment,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
