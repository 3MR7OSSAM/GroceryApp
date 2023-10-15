import 'package:flutter/material.dart';

import '../../btm_bar_screen.dart';
class ApprovedPayment extends StatelessWidget {
  const ApprovedPayment({Key? key, required this.isVisa}) : super(key: key);
  final bool isVisa ;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('Assets/checckout/Approved.png',width: size.height*0.19,)),
            Center(child: Text(isVisa ?'Payment Approved' : 'Order submitted Successfully', style: const TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 28),)),
            SizedBox(height: size.height*0.02,),
            isVisa ?const Text('Order Created Successfully',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,decoration: TextDecoration.underline),):const SizedBox(),
            SizedBox(height: size.height*0.05,),
            FloatingActionButton(
              backgroundColor: Colors.green,
                child: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const BottomBar()));
              //
            })
          ],
        ),
      ),
    );
  }
}
