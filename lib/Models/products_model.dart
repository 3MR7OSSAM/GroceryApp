import 'package:flutter/foundation.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, productCategoryName,unit;
  final String price, salePrice;
  final bool isOnSale;

  ProductModel(
      {required this.id,
      required this.title,
      required this.unit,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
     });
}
