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
  final double weight;
  final bool isWeighted;

  const CartItemModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.unitsPerBox,
    required this.boxes,
    required this.units,
    this.weight = 0.0,
    this.isWeighted = false,
  });

  /// Total units = (Boxes * units_per_box) + Units (for standard items)
  int get totalUnits => (boxes * unitsPerBox) + units;

  /// Total quantity (weight for weighted, totalUnits for standard)
  num get totalQuantity => isWeighted ? weight : totalUnits;

  /// Total price for this line item based on units or weight.
  /// Price is the unit price (or per kg for weighted).
  double get lineTotal => price.toDouble() * totalQuantity;

  CartItemModel copyWith({int? boxes, int? units, double? weight}) {
    // Apply conversion rule
    int newBoxes = boxes ?? this.boxes;
    int newUnits = units ?? this.units;
    double newWeight = weight ?? this.weight;
    
    if (!isWeighted && newUnits >= unitsPerBox) {
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
      weight: newWeight,
      isWeighted: isWeighted,
    );
  }

  /// Convert to the format expected by the backend create-order endpoint.
  Map<String, dynamic> toOrderPayload() => {
        'productId': productId,
        'quantity': totalQuantity, 
      };

  @override
  List<Object?> get props => [productId, boxes, units, weight, isWeighted];
}
