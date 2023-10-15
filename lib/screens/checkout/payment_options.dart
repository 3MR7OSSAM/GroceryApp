import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/allProviders/userProvider.dart';
import '../../allProviders/payment_provider.dart';
import 'Address_confirmation.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key, required this.cartTotal}) : super(key: key);
  final String cartTotal;

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  String selectedOption = '';
  String ?title;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.returnData();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back,)),
                  const Spacer(flex: 1,),
                  const Text('Checkout', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),),
                  const Spacer(flex: 1,),
                ],
              ),
            ),
            SizedBox(height: height * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: height * 0.03),
              child: Material(
                color: Theme
                    .of(context)
                    .cardColor,
                borderRadius: BorderRadius.circular(20),
                elevation: selectedOption == 'Pay With Card' ? 10 : 3,
                child: ListTile(
                  trailing: Image.asset('Assets/checckout/card_logo.png',
                    width: height * 0.06,),
                  title: const Text('Pay With Card'),
                  leading: Radio(
                    activeColor: Colors.blue,
                    value: '0',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        title = 'Process to pay ${widget.cartTotal} EGP.';
                        selectedOption = value.toString();
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(height * 0.03),
              child: Material(
                color: Theme
                    .of(context)
                    .cardColor,
                borderRadius: BorderRadius.circular(20),
                elevation: selectedOption == 'Cash on Delivery' ? 20 : 3,
                child: ListTile(
                  trailing: Image.asset('Assets/checckout/payDoor.png',
                    width: height * 0.06,),
                  title: const Text('Cash on Delivery'),
                  leading: Radio(
                    activeColor: Colors.blue,
                    value: '1',
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        title = 'Process to confirm your address';
                        selectedOption = value.toString();
                      });
                    },
                  ),
                ),
              ),
            ),
            const Expanded(child: SizedBox(),),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: height * 0.02, vertical: height * 0.03),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8)
                ),
                child: InkWell(
                  child: Container(
                    color: Colors.blue,
                    width: double.infinity,
                    height: height * 0.07,
                    child: Center(
                      child: Text(
                        title ?? 'Selected payment option',
                        style: TextStyle(fontSize: height * 0.02, color: Colors
                            .white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  onTap: () {
                    final orderTotal = double.parse(widget.cartTotal);
                   // paymentProvider.getFirstToken(orderTotal, userData.name.toString(), "SecondName", userData.email.toString(),'011111111111', context);

                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                    selectedOption == '0' ?
                  paymentProvider.getFirstToken(
                      orderTotal*100, userData.name.toString(),
                        userData.name.toString(),userData.email.toString(), '01146012354',
                         context):
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddressConfirmation()));
                  },
                ),
              ),
            )
          ],

        ),),
    );
  }
}
