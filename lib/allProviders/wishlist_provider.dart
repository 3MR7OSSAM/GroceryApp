import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../Models/wishlist-model.dart';
import '../methods/btm_alert.dart';
class WishListProvider with ChangeNotifier {
  final Map<String, WishListModel> _wishedItems = {};
  final User? user = FirebaseAuth.instance.currentUser;


  Map<String, WishListModel> get getWishListItems {
    return _wishedItems;
  }



  Future<void> addOrRemoveWishItem({required String productID, required String id, context}) async {
    try {
      _wishedItems.putIfAbsent(productID, () => WishListModel(id: id, productID: productID));
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await userDocRef.get();
      final userWishlist = userDocSnapshot.get('userWishlist') ?? [];
      final isProductInWishlist = userWishlist.any((item) => item['productId'] == productID);
      if (!isProductInWishlist) {
        await userDocRef.update({
          'userWishlist': FieldValue.arrayUnion([
            {
              'wishListID': id,
              'productId': productID,
            }
          ])
        });
      }else {
        await userDocRef.update({
          'userWishlist': FieldValue.arrayRemove([
            {
              'wishListID': id,
              'productId': productID,
            }
          ])
        });
        _wishedItems.remove(productID);
        notifyListeners();
      }
    } catch (e) {
      showBtmAlert(context, '$e');
    }
  }

  Future<void> fetchWish(context) async {

    if (user!=null) {
      try {
        final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
          final len = userDoc.get('userCart').length;
          for (int i = 0; i < len; i++) {
            _wishedItems.putIfAbsent(
              userDoc.get('userWishlist')[i]['productId'],
                  () => WishListModel(
                id: userDoc.get('userWishlist')[i]['wishListID'],
                productID: userDoc.get('userWishlist')[i]['productId'],
              ),
            );
        }
      } catch (e) {
        showBtmAlert(context, '$e');
      }
    }
    notifyListeners();
  }



  void removeWishedItem({required String productID, required String id, context})async{
    try {
      _wishedItems.putIfAbsent(productID, () => WishListModel(productID: productID, id: id));
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      final userDocSnapshot = await userDocRef.get();
      final userWishlist = userDocSnapshot.get('userWishlist') ?? [];
      final isProductInWishlist = userWishlist.any((item) => item['productId'] == productID);
      if (!isProductInWishlist) {
        final wishListId = const Uuid().v4();
        await userDocRef.update({
          'userWishlist': FieldValue.arrayRemove([
            {
              'wishListID': wishListId,
              'productId': productID,
            }
          ])
        });

      }

    } catch (e) {
      showBtmAlert(context, '$e');
    }
    _wishedItems.remove(productID);
    notifyListeners();
  }


  void clearWishes(context) async{
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'userWishlist': []
      });
    } catch (e) {
      showBtmAlert(context, '$e');
    }
    _wishedItems.clear();
    notifyListeners();
  }

}
