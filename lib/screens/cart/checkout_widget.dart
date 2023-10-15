import 'package:GroceryApp/methods/btm_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/cart_model.dart';
import '../../allProviders/payment_provider.dart';
import '../../allProviders/product_provider.dart';
import '../../allProviders/userProvider.dart';
import '../checkout/payment_options.dart';

class CheckOutWidget extends StatelessWidget {

  final List<CartModel> cartItems;
   const CheckOutWidget({super.key, required this.cartItems,});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.returnData();

    final productProvider = Provider.of<ProductProvider>(context);
    double totalPrice = 0.0;
    var size = MediaQuery
        .of(context)
        .size;
    cartItems.forEach((element) {
      final currentProduct = productProvider.findByID(element.productID);
      String price  = double.parse(currentProduct.salePrice) == 0.0 ? currentProduct.price: currentProduct.salePrice;
      totalPrice += double.parse(price) * element.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.09,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async{
                if (userData.address != null ) {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentOptions(cartTotal: totalPrice.toStringAsFixed(2),)));
                }
                else{
                  showBtmAlert(context, 'Please add your address to your profile to continue');
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Order Now',style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
            const Spacer(),
             FittedBox(child: Text('Total price ${totalPrice.toStringAsFixed(2)} EGP',
              style: const TextStyle(fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}
