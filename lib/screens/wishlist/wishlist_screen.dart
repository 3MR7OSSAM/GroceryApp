import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/wishlist-model.dart';
import 'package:GroceryApp/screens/wishlist/wishlist_widget.dart';
import '../../methods/ShowDialog.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/wishlist_provider.dart';
import '../../btm_bar_screen.dart';
import '../empty_screen/empty_screen.dart';
class WishScreen extends StatelessWidget {
  const WishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final wishListProvider = Provider.of<WishListProvider>(context);
    List <WishListModel> wishedItems = wishListProvider.getWishListItems.values.toList().reversed.toList();
    return wishedItems.isEmpty ? const EmptyScreen(
      appBarTitle: 'WishList',

      image: Image(image: AssetImage('Assets/wishlist.png')), title: '" No Wishes Yet "',buttonTitle:'Add Wishes Now',page: BottomBar(),):Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: color,
          ),
          actions: [
            IconButton(onPressed: ()
              async{
               await showLogoutDialog(context,' Are You Sure ','Empty Your WishList ?',(){
                 wishListProvider.clearWishes(context);
                 Navigator.pop(context);
                 wishListProvider.clearWishes(context);
               });
              },
             icon: Icon(Icons.delete_outline_rounded,color: themeState.getDarkTheme ? Colors.white : Colors.black))
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title:Text('WishList' ,style: TextStyle(color: themeState.getDarkTheme ? Colors.white : Colors.black),),
        ),
        body: ListView.builder(
          itemCount: wishedItems.length,
          itemBuilder: (context , index){
          return  ChangeNotifierProvider.value(
              value: wishedItems[index],
              child: const WishWidget());
        })
    );
  }
}
