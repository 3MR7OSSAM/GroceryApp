import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/cart_model.dart';
import 'package:GroceryApp/allProviders/order_provider.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/cart_provider.dart';
import '../../btm_bar_screen.dart';
import 'cart_widget.dart';
import 'checkout_widget.dart';
import '../empty_screen/empty_screen.dart';
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    List<CartModel> cartItems = cartProvider.getCartItems.values.toList().reversed.toList();
    final themeState = Provider.of<DarkThemeProvider>(context);
    return cartItems.isEmpty ?  const EmptyScreen(
      appBarTitle: 'Cart ',
      image: Image(image: AssetImage('Assets/cart-is-empty.png')), title: '" Yor cart is empty "',buttonTitle:'ShopNow' ,page: BottomBar(),) : Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(onPressed: (){
              cartProvider.clearCart(context);
            }, icon: Icon(Icons.delete_outline_rounded,color: themeState.getDarkTheme ? Colors.white : Colors.black))
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title:Text('Cart ${cartItems.length}' ,style: TextStyle(color: themeState.getDarkTheme ? Colors.white : Colors.black),),
        ),
      body:  Column(
        children: [
          MultiProvider(
              providers: [
                ChangeNotifierProvider(create:(_){
                 return OrderProvider();
                })
              ],
              child: CheckOutWidget(cartItems: cartItems,)),
          Expanded(
            child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context,index){
                  return ChangeNotifierProvider.value(
                      value: cartItems[index],
                      child:  CartWidget(quantity: cartItems[index].quantity.toString()));
                }
            ),
          ),
        ],
      )
    );
  }
}
