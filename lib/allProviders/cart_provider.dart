import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:GroceryApp/Models/cart_model.dart';
import 'package:uuid/uuid.dart';
import '../methods/btm_alert.dart';
class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};
  final User? user = FirebaseAuth.instance.currentUser;

  Map<String, CartModel> get getCartItems {
    return _cartItems;
  }
  Future<void> addCartItems(
      {required String productID, required int quantity, context}) async {
    final cartId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productID,
            'quantity': quantity,
          }
        ])
      });
    } catch (e) {
      showBtmAlert(context, '$e');
    }
  }

  Future<void> fetchCartItems(context) async {

    if (user!= null) {
      try {
        final DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
          final len = userDoc.get('userCart').length;
          for (int i = 0; i < len; i++) {
            _cartItems.putIfAbsent(
              userDoc.get('userCart')[i]['productId'],
              () => CartModel(
                id: userDoc.get('userCart')[i]['cartId'],
                productID: userDoc.get('userCart')[i]['productId'],
                quantity: userDoc.get('userCart')[i]['quantity'],
              ),
            );
        }
      } catch (e) {
        showBtmAlert(context, '$e');
      }
    }
    notifyListeners();

  }

  void reduceCartItems(String productID) {
    _cartItems.update(
        productID,
        (value) => CartModel(
            id: value.id, productID: productID, quantity: value.quantity - 1));
  }

  void increaseCartItems(String productID) {
    _cartItems.update(
        productID,
        (value) => CartModel(
            id: value.id, productID: productID, quantity: value.quantity + 1));
    notifyListeners();
  }



  Future<void> removeCartItem(
      {required String productID,required String cartId, required int quantity, context}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userCart': FieldValue.arrayRemove([
          {
            'cartId': cartId,
            'productId': productID,
            'quantity': quantity,
          }
        ])
      });
    } catch (e) {
      showBtmAlert(context, '$e');
    }
    _cartItems.remove(productID);
    notifyListeners();
  }



  void clearCart(context) async{
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userCart': []
      });
    } catch (e) {
      showBtmAlert(context, '$e');
    }
    _cartItems.clear();
    notifyListeners();
  }
}
