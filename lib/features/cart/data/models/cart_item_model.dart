import 'package:equatable/equatable.dart';

/// Represents a single item in the local cart before an order is placed.
class CartItemModel extends Equatable {
  final String productId;
  final String title;
  final String image;
  final num price;
  final int units;
  final int quantity; // number of boxes

  const CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.units,
    required this.quantity,
  });

  /// Total price for this line item.
  double get lineTotal => price.toDouble() * quantity;

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      title: title,
      image: image,
      price: price,
      units: units,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Convert to the format expected by the backend create-order endpoint.
  Map<String, dynamic> toOrderPayload() => {
        'productId': productId,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [productId, quantity];
}
