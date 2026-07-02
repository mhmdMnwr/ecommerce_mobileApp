import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  final String productId;
  final String? title;
  final String? image;
  final num quantity;
  final int units;
  final num price;
  @JsonKey(defaultValue: false)
  final bool isWeighted;

  const OrderItemModel({
    required this.productId,
    this.title,
    this.image,
    required this.quantity,
    required this.units,
    required this.price,
    this.isWeighted = false,
  });

  /// Total price for this line item based on unit price × total quantity.
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
  /// Stamped by the backend when status changes to Delivered.
  final DateTime? deliveredAt;

  const OrderModel({
    required this.id,
    required this.customerId,
    required this.items,
    this.comment,
    required this.totalAmount,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deliveredAt,
  });

  /// Whether the order can be edited/cancelled by the customer.
  bool get isPending => status == 'Pending';

  /// Total number of individual product units across all line items.
  num get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
