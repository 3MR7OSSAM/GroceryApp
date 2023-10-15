import 'package:flutter/material.dart';
class HistoryModel with ChangeNotifier {
  final String id, productID;
  HistoryModel( {
    required this.id,
    required this.productID,
  });
}
