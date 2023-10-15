import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/history_model.dart';
import '../../allProviders/cart_provider.dart';
import '../../allProviders/product_provider.dart';
import '../Buttom_bar_screens/product_details.dart';
class HistoryWidget extends StatelessWidget {
  const HistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyModel= Provider.of<HistoryModel>(context);
    final productProvider= Provider.of<ProductProvider>(context);
    final currentProduct= productProvider.findByID(historyModel.productID);
    final price = currentProduct.isOnSale?currentProduct.salePrice:currentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(currentProduct.id);

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(productID: currentProduct.id,)));
        },
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          shadowColor: Colors.black,

          child: ListTile(

            minVerticalPadding: 30,
            title:  Center(child: Text(currentProduct.title)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Center(child: Text( '$price EGP',style: TextStyle(color: Colors.green.withOpacity(0.9)),)),
            ),
            leading: FancyShimmerImage(
              imageUrl: currentProduct.imageUrl,
              width: 70,
              boxFit: BoxFit.fitHeight,
            ),
            trailing:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                      cartProvider.addCartItems( productID: currentProduct.id, quantity: 1,context: context);
                  },
                  child: isInCart ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_circle,
                        size: 25,
                        color: Colors.blue,
                      ),
                      Text('In Cart')
                    ],
                  ): const Icon(
                    CupertinoIcons.cart_badge_plus,
                    size: 25,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
