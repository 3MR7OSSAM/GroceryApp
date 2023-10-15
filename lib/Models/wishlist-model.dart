import 'package:flutter/material.dart';
class WishListModel with ChangeNotifier {
  final String id, productID;
  WishListModel( {
    required this.id,
    required this.productID,
  });
}
