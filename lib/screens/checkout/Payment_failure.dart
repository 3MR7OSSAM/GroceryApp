import 'package:flutter/material.dart';
import 'package:GroceryApp/screens/cart/cart_screen.dart';

class FailurePayment extends StatelessWidget {
  const FailurePayment({Key? key}) : super(key: key);

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
            Center(child: Image.asset('Assets/checckout/NotApproved.png',width: size.height*0.19,)),
            const Text('Payment Failure', style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 28),),
            SizedBox(height: size.height*0.02,),
            const Text('Please try again',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,decoration: TextDecoration.underline),),
            SizedBox(height: size.height*0.05,),
            FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
                  //
                })
          ],
        ),
      ),
    );
  }
}
