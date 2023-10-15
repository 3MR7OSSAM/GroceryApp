
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GroceryApp/Models/userModel.dart';

import '../methods/btm_alert.dart';

class UserProvider with ChangeNotifier{
  bool isLoading = false;
  final User? user = FirebaseAuth.instance.currentUser;
  final UserModel userData = UserModel();
  Future<void> getUserData() async {
    try {
      String uid = user!.uid;
      final  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (user == null) {
        userData.name =userDoc.get('name');
        userData.email = userDoc.get('email');
        userData.address = userDoc.get('address');
      }else{
        userData.name = user!.displayName;
        userData.email = user!.email;
        userData.address = userDoc.get('address');
      }
      //print(userData.address);
    } catch (error) {
      //print(error);
    } finally {
    }
  }
  UserModel returnData(){
    if(userData.name == null){
      getUserData();
      return userData;
    }else if(userData.name != null) {
      return userData;
    }else{
      userData.name = 'User';
      userData.email = 'user@example.com';
      userData.address = "Add Address Now";
      return userData;

    }
  }
  void updateAddress(String address,  context ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'address' :  address,
      });
       notifyListeners();
    }catch(err){
      showBtmAlert(context , err.toString());
    }
  }
  UserModel clearUserData(){
      userData.name = 'User';
      userData.email = 'user@example.com';
      userData.address = "Add Address Now";
      return userData;

  }
}
