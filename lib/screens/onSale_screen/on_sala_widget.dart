import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/widgets/price_widget.dart';
import '../../Models/products_model.dart';
import '../../methods/show_alert.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/cart_provider.dart';
import '../../allProviders/wishlist_provider.dart';
import '../Buttom_bar_screens/product_details.dart';

class OnSale extends StatefulWidget {
  const OnSale({Key? key}) : super(key: key);

  @override
  State<OnSale> createState() => _OnSaleState();
}

class _OnSaleState extends State<OnSale> {
  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double screenWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? isInWishList =
        wishListProvider.getWishListItems.containsKey(productModel.id);
    final User? user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        width: screenWidth * 0.35,
        height: screenWidth * 0.32,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                    productID: productModel.id,
                                  )));
                    },
                    child: FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: screenWidth * 0.14,
                      width: screenWidth * 0.17,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1KG',
                        style: TextStyle(color: color, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: ()  async{
                                if (user == null)
                                  {
                                    showAlertBar(context, () {});
                                  }else{
                                  cartProvider.addCartItems( productID: productModel.id, quantity: 1,context: context);

                                  await cartProvider.fetchCartItems(context);
                                }
                            },
                              child: isInCart
                                  ? const Icon(
                                      Icons.shopping_bag,
                                      size: 22,
                                      color: Colors.blue,
                                      fill: 1,
                                    )
                                  : Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 22,
                                      color: color,
                                    )),
                          InkWell(
                              onTap: () async {
                                    if (user == null)
                                      {
                                        showAlertBar(context, () {});
                                      }
                                    else
                                      {
                                        const CircularProgressIndicator();
                                        wishListProvider.addOrRemoveWishItem(productID: productModel.id,context: context, id: productModel.id);
                                        await wishListProvider.fetchWish(context);
                                      }
                                  },
                              child: isInWishList
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 22,
                                      color: Colors.red,
                                      fill: 1,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 22,
                                      color: color,
                                    ))
                        ],
                      )
                    ],
                  )
                ],
              ),
              PriceWidget(
                salePrice: double.parse(productModel.salePrice),
                price: double.parse(productModel.price),
                textPrice: '1',
                isOnSale: true,
              ),
              const SizedBox(height: 5),
              Center(
                  child: Text(
                productModel.title,
                maxLines: 2,
                style: TextStyle(color: color),
              )),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
