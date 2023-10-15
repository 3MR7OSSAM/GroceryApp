import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/allProviders/product_provider.dart';
import '../../Models/cart_model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/cart_provider.dart';
import '../Buttom_bar_screens/product_details.dart';
import 'quantity_widget.dart';
class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.quantity}) : super(key: key);
  final String quantity;
  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final TextEditingController _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.quantity;
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
    final cartModel = Provider.of<CartModel>(context);
    final currentProduct = productProvider.findByID(cartModel.productID);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(productID: currentProduct.id,)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  height: screenWidth * 0.22,
                  width: screenWidth * 0.22,
                  child: FancyShimmerImage(
                    imageUrl: currentProduct.imageUrl,
                    boxFit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: screenWidth*0.4,
                      child: Text(
                        currentProduct.title,
                        style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                            maxLines: 3,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: screenWidth*0.23,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: QuantityWidget(
                              icon: CupertinoIcons.add,
                              onTap: () {
                                cartProvider.increaseCartItems(currentProduct.id);
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
                                if (int.parse(_quantityTextController.text) <= 1) {
                                  return 1;
                                }

                                  cartProvider.reduceCartItems(currentProduct.id);
                                  setState(() {
                                  _quantityTextController.text =
                                      (int.parse(_quantityTextController.text) -
                                          1)
                                          .toString();
                                });
                              },
                              color: Colors.red,
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () async {

                            cartProvider.removeCartItem( productID:cartModel.productID, quantity: cartModel.quantity, cartId: cartModel.id);
                              cartProvider.getCartItems;
                              await cartProvider.fetchCartItems(context);
                          },
                          child: const Icon(
                            CupertinoIcons.cart_badge_minus,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      ),
                       Text(
                        '${
                          currentProduct.isOnSale
                              ? (double.parse(currentProduct.salePrice) * int.parse(_quantityTextController.text)).toStringAsFixed(2)
                              : (double.parse(currentProduct.price)* int.parse(_quantityTextController.text)).toStringAsFixed(2)
                        } EGP',style: const TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
