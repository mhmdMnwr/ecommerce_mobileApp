import 'package:equatable/equatable.dart';

/// Represents a single item in the local cart before an order is placed.
class CartItemModel extends Equatable {
  final String productId;
  final String title;
  final String image;
  final num price;
  final int unitsPerBox;
  final int boxes;
  final int units;

  const CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.unitsPerBox,
    required this.boxes,
    required this.units,
  });

  /// Total units = (Boxes * units_per_box) + Units
  int get totalUnits => (boxes * unitsPerBox) + units;

  /// Total price for this line item based on units.
  /// Price is the unit price.
  double get lineTotal => price.toDouble() * totalUnits;

  CartItemModel copyWith({int? boxes, int? units}) {
    // Apply conversion rule
    int newBoxes = boxes ?? this.boxes;
    int newUnits = units ?? this.units;
    
    if (newUnits >= unitsPerBox) {
      newBoxes += newUnits ~/ unitsPerBox;
      newUnits = newUnits % unitsPerBox;
    }

    return CartItemModel(
      productId: productId,
      title: title,
      image: image,
      price: price,
      unitsPerBox: unitsPerBox,
      boxes: newBoxes,
      units: newUnits,
    );
  }

  /// Convert to the format expected by the backend create-order endpoint.
  Map<String, dynamic> toOrderPayload() => {
        'productId': productId,
        'quantity': totalUnits, // Assuming backend expects total units or whatever quantity means. Will adjust if needed.
      };

  @override
  List<Object?> get props => [productId, boxes, units];
}
