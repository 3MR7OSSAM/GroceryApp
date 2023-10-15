import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/allProviders/cart_provider.dart';

import '../../Models/wishlist-model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/history_provider.dart';
import '../../allProviders/product_provider.dart';
import '../../allProviders/wishlist_provider.dart';
import '../cart/quantity_widget.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.productID}) : super(key: key);
  final String productID;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final TextEditingController _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.findByID(widget.productID);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final wishProvider= Provider.of<WishListProvider>(context);
    var size = MediaQuery.of(context).size;
    bool? isInCart = cartProvider.getCartItems.containsKey(product.id);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final price = ((double.parse(_quantityTextController.text)) *
            double.parse(product.price))
        .toStringAsFixed(2);
    final User? user = FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: () async {
        if (user != null) {
          historyProvider.addOtoViewedItem(product.id);
          return true;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: color,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: size.height * 0.4,
                    child: FancyShimmerImage(
                      imageUrl: product.imageUrl,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.8,
                      child: Text(
                        product.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 3,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: product.isOnSale
                              ? double.parse(product.salePrice)
                                  .toStringAsFixed(2)
                              : double.parse(product.price).toStringAsFixed(2),
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: product.unit == 'piece' ? '  /Piece' : '  /KG',
                          style: TextStyle(
                            color: color,
                          )),
                    ])),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Free Delivery',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: QuantityWidget(
                        icon: CupertinoIcons.add,
                        onTap: () {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) + 1)
                                    .toString();
                          });
                        },
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Center(
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide())),
                            keyboardType: TextInputType.number,
                            controller: _quantityTextController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'))
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _quantityTextController.text = '1';
                              } else {
                                return;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: QuantityWidget(

                        icon: CupertinoIcons.minus,

                        onTap: () {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) - 1)
                                    .toString();
                          });
                        },
                        color : Colors.red,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * .17),
                  child: Row(
                    children: [
                      FittedBox(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '$price EGP',
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                              TextSpan(
                                text: ' / ${_quantityTextController.text} ',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: isInCart
                            ? null
                            : () {
                                cartProvider.addCartItems(
                                    productID: product.id, quantity: 1);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              isInCart ? 'In Cart' : 'Add to cart',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
