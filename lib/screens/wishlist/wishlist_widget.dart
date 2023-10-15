import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/wishlist-model.dart';
import 'package:GroceryApp/allProviders/product_provider.dart';
import 'package:GroceryApp/allProviders/wishlist_provider.dart';

import '../../methods/btm_alert.dart';
import '../../allProviders/cart_provider.dart';
import '../Buttom_bar_screens/product_details.dart';
class WishWidget extends StatelessWidget {
  const WishWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishModel= Provider.of<WishListModel>(context);
    final wishProvider= Provider.of<WishListProvider>(context);
    final productProvider= Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final currentProduct= productProvider.findByID(wishModel.productID);
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(

        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 10,
        shadowColor: Colors.black,

        child: GestureDetector(
          onTap: () =>Navigator.push(context, MaterialPageRoute(builder: (constant)=> ProductDetails(productID: currentProduct.id,))),

          child: ListTile(
            minVerticalPadding: 30,
            title: Text(currentProduct.title),
            subtitle: Text('\$0.99',style: TextStyle(color: Colors.green.withOpacity(0.9)),),
            leading: FancyShimmerImage(
              imageUrl: currentProduct.imageUrl,
              width: 70,
              boxFit: BoxFit.fitHeight,
            ),
            trailing:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    cartProvider.addCartItems( productID: wishModel.productID, quantity: 1,context: context);
                    showBtmAlert(context , 'item  added successfully  to the cart');
                  },
                  child:  const Icon(
                    CupertinoIcons.cart,
                    size: 22,
                    color: Colors.blue,
                  ),
                ),
                InkWell(
                  onTap: () {
                    wishProvider.addOrRemoveWishItem( productID: wishModel.productID ,context: context, id: wishModel.id);
                  },
                  child: const Icon(
                    CupertinoIcons.heart_slash,
                    color: Colors.red,
                    size: 22,
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
