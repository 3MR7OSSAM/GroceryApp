import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:GroceryApp/screens/login_screen/login_screen.dart';

void successAlertBar(context , String message){
  CherryToast.success(
    backgroundColor: Theme.of(context).cardColor,
    action: GestureDetector(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen())),
        child:  Center(child: Text(message,style: const TextStyle( color: Colors.blue,fontSize: 12),))),
    title: const Text(''),
    enableIconAnimation: false,
    displayTitle: false,
    animationDuration: const Duration(milliseconds: 500),
    autoDismiss: true,
  ).show(context);
}