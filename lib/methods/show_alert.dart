import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:GroceryApp/screens/login_screen/login_screen.dart';

void showAlertBar(context , Function onPress ){
  CherryToast.info(
    backgroundColor: Theme.of(context).cardColor,
    actionHandler: (){

    },
    action: GestureDetector(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen())),
        child: const Text(' You need Sign In First !',style: TextStyle(color: Colors.blue),)),
    title: const Text(''),
    enableIconAnimation: false,
    displayTitle: false,
    animationDuration: const Duration(milliseconds: 1000),
    autoDismiss: false,
  ).show(context);
}