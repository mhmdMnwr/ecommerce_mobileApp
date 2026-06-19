import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  final String productId;
  final String? title;
  final int quantity;
  final int units;
  final num price;

  const OrderItemModel({
    required this.productId,
    this.title,
    required this.quantity,
    required this.units,
    required this.price,
  });

  /// Total price for this line item.
  double get lineTotal => price.toDouble() * quantity;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  @JsonKey(name: '_id')
  final String id;
  final String customerId;
  final List<OrderItemModel> items;
  final String? comment;
  final num totalAmount;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    this.comment,
    required this.totalAmount,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Whether the order can be edited/cancelled by the customer.
  bool get isPending => status == 'Pending';

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
