import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Models/oredr_model.dart';
import '../methods/btm_alert.dart';
const ordersCollection = 'orders';
const productIdField = 'product_id';
final User? user = FirebaseAuth.instance.currentUser;

class OrderProvider with ChangeNotifier {
  static final List<OrderModel> _ordersList = [];

  List<OrderModel> get getOrders {
    return _ordersList;
  }

  Future<void> addOrder(
      {required String productId,
      required String price,
      required double totalPrice,
      required int quantity,
      required String imageUrl,
      required String unit,
      required String productName,
      required String paymentOption,
      required context
      }) async {
    final orderId = const Uuid().v4();
    try {
      String name,address,email;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      name = userDoc.get('name');
      address = userDoc.get('address');
      email = userDoc.get('email');
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'user_name': name,
        'address'  : address,
        'email'    : email,
        'order_id': orderId,
        'productName':productName,
        'unit':unit,
        'product_id': productId,
        'price': price,
        'total_price': totalPrice,
        "payment_option" : paymentOption,
        'quantity': quantity,
        'imageUrl': imageUrl,
        'status'  :'Processing',
        'order_dat': Timestamp.now(),
      });

    } catch (e) {
      showBtmAlert(context, '$e');
    }
    notifyListeners();
  }
  Future<void> fetchOrders(context) async {
    try {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection(ordersCollection).where('user_id' , isEqualTo: user!.uid)
          .get();
      OrderModel createOrderModel(QueryDocumentSnapshot doc) {
        return OrderModel(
          productId: doc.get('product_id'),
          orderId:  doc.get('order_id'),
          userId:  doc.get('user_id'),
          userName:  doc.get('user_name'),
          imageUrl:  doc.get('imageUrl'),
          price:  doc.get('price'),
          quantity:  doc.get('quantity'),
          orderDate:  doc.get('order_dat'),
          productName: doc.get('productName'),
          orderTotal: doc.get('total_price'),
          unit : doc.get('unit'),

        );
      }
      for (var doc in orderSnapshot.docs) {
        _ordersList.insert(0, createOrderModel(doc));
      }
    } on FirebaseException catch (e) {
      showBtmAlert(context, 'Error fetching orders: $e');
    }

    notifyListeners();
  }
}
