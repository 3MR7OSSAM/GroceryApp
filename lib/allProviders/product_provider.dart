import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/products_model.dart';

class ProductProvider with ChangeNotifier {
  static final List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get onSale {
    return _productsList.where((element) => element.isOnSale).toList();
  }
  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      for (var element in productSnapshot.docs) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get('id'),
              title: element.get('name'),
              imageUrl: element.get('imageUrl'),
              productCategoryName: element.get('category'),
              price: element.get('price').toString(),
              salePrice: element.get('salePrice').toString(),
              unit:element.get('unit'),
              isOnSale:element.get('salePrice') != 0 ? true : false ,

            ));
      }
    });
    notifyListeners();
  }
  ProductModel findByID(String id) {
    return _productsList.firstWhere((element) => element.id == id);
  }

  List<ProductModel> findByCategory(String category) {
    return _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(category.toLowerCase()))
        .toList();
  }
  List<ProductModel> searchQuery(String searchText) {
    return _productsList
        .where((element) => element.title
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();
  }
  @override
  notifyListeners();

}
