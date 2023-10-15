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

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();

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
    final productModel = Provider.of<ProductModel>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    double screenWidth = MediaQuery.of(context).size.width;
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishListProvider = Provider.of<WishListProvider>(context);
    bool? isInWishList = wishListProvider.getWishListItems.containsKey(productModel.id);
    final User? user = FirebaseAuth.instance.currentUser;

    return InkWell(
        // onTap: (){},
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        children: [
          Column(
            children: [
              GestureDetector(
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
                  height: screenWidth * 0.20,
                  width: screenWidth * 0.20,
                  boxFit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth*0.25,
                      child: Text(
                        productModel.title,
                        maxLines: 2,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                        onTap: ()async{
                          wishListProvider.addOrRemoveWishItem(productID: productModel.id,context: context, id: productModel.id);
                          wishListProvider.fetchWish(context);
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PriceWidget(
                      salePrice: double.parse(productModel.salePrice),
                      price: double.parse(productModel.price),
                      textPrice: '1',
                      isOnSale: productModel.isOnSale,
                    ),
                    const Spacer(flex: 1,),
                    Flexible(
                      flex: 2,
                      child: Text(
                       productModel.unit == 'piece' ? 'piece' : 'KG',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: isInCart
                    ? null
                    : () async {
                  if (user == null)
                  {
                    showAlertBar(context, () {});
                  }else{
                  cartProvider.addCartItems( productID: productModel.id, quantity: 1,context: context);
                  await cartProvider.fetchCartItems(context);
                  }
              },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color:isInCart ? Colors.white :Colors.blue ,
                      borderRadius: BorderRadius.circular(6)),
                  width: double.infinity,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isInCart ? const Icon(Icons.check_circle_outline,color: Colors.blue,):const Icon(Icons.shopping_bag_outlined,color: Colors.white,),
                        const SizedBox(width: 2,),
                        Text(
                          isInCart ? 'In Cart' : 'Add to cart',
                          style:  TextStyle(
                              color: isInCart ?Colors.black :Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
