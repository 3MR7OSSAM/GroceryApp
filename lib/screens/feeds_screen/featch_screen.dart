import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/allProviders/cart_provider.dart';
import 'package:GroceryApp/allProviders/order_provider.dart';
import 'package:GroceryApp/allProviders/wishlist_provider.dart';
import '../../allProviders/product_provider.dart';
import '../../allProviders/userProvider.dart';
import '../../btm_bar_screen.dart';
class fetchScreen extends StatefulWidget {
  const fetchScreen({Key? key}) : super(key: key);

  @override
  State<fetchScreen> createState() => _fetchScreenState();
}

class _fetchScreenState extends State<fetchScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 8),()async{
      final productProvider = Provider.of<ProductProvider>(context,listen: false);
      final cartProvider = Provider.of<CartProvider>(context,listen: false);
      final wishListProvider = Provider.of<WishListProvider>(context,listen: false);
      final orderProvider = Provider.of<OrderProvider>(context,listen: false);
      final userProvider = Provider.of<UserProvider>(context,listen: false);
      userProvider.returnData();
      await productProvider.fetchProducts();
      await orderProvider.fetchOrders(context);
      await wishListProvider.fetchWish(context);
      await cartProvider.fetchCartItems(context);
      if (context.mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const BottomBar()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
       child: AnimatedTextKit(
         pause: const Duration(microseconds: 600),
         totalRepeatCount: 1,
         animatedTexts: [
           FadeAnimatedText('Shopify',
               textStyle: const TextStyle(
                   color: Colors.blue,
                   fontSize: 62,
                   fontWeight: FontWeight.bold,
               ))
         ],
       ),
      ),
    );
  }
}
