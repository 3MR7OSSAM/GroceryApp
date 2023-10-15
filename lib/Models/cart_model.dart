import 'package:flutter/material.dart';
class CartModel with ChangeNotifier {
  final String id, productID;
  final int quantity;
  CartModel({
    required this.id,
    required this.productID,
    required this.quantity,
  });
}
