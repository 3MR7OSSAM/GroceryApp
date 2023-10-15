import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/allProviders/cart_provider.dart';
import 'package:GroceryApp/allProviders/userProvider.dart';
import 'package:GroceryApp/allProviders/wishlist_provider.dart';
import 'package:GroceryApp/screens/wishlist/wishlist_screen.dart';
import '../../methods/ShowDialog.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../widgets/UserListTile.dart';
import '../history/history_screen.dart';
import '../login_screen/login_screen.dart';
import '../orders/orders_screen.dart';
import 'forgot_password.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController addressEditingController = TextEditingController();
  @override
  void dispose() {
    addressEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishProvider = Provider.of<WishListProvider>(context);
    final User? user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.returnData();
    addressEditingController.text = userData.address ?? '';
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
               ListTile(
                title: Text.rich(
                  TextSpan(children: <InlineSpan>[
                    const TextSpan(
                      text: 'Hi, ',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),
                    ),
                    TextSpan(
                      text: userData.name ?? 'UserName',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ),
                subtitle: Text(
                  userData.email??'email@example.com',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: const Divider(
                  color: Colors.grey,
                ),
              ), // A horizontal line

              UserListTile(
                title: 'Address',
                subtitle: userData.address ?? '',
                icon: const Icon(IconlyLight.profile),
                onPress: () async {
                  await ShowDialog(context);
                },
              ),
              UserListTile(
                title: 'Order',
                icon: const Icon(IconlyLight.bag),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrdersScreen()));

                },
              ),
              UserListTile(
                title: 'Wishlist',
                icon: const Icon(IconlyLight.heart),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const WishScreen()));
                },
              ),
              UserListTile(
                title: 'Viewed',
                icon: const Icon(IconlyLight.show),
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const HistoryScreen()));
                },
              ),
              UserListTile(
                title: 'Forgot Password',
                icon: const Icon(IconlyLight.unlock),
                onPress: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                },
              ),
              SwitchListTile(
                title: const Text('Theme'),
                secondary: Icon(themeState.getDarkTheme
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined),
                onChanged: (bool value) {
                  setState(() {
                    themeState.setDarkTheme = value;
                  });
                },
                value: themeState.getDarkTheme,
              ),
              UserListTile(
                title: user != null ?'Sign out':'Sign in',
                icon:  user != null ? const Icon(IconlyLight.logout):const Icon(IconlyLight.login)  ,
                onPress: () async{
                  if (user!=null){
                    await showLogoutDialog(context,'SignOut','Are you sure you want to Sign Out ?',(){
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      setState(() {
                        userData.email = 'user@example.com';
                        userData.name = 'User';
                        userData.address= 'example 24 st mart st';
                      });
                      cartProvider.clearCart(context);
                      wishProvider.clearWishes(context);
                    });
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> ShowDialog(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Address'),
            content: TextField(
              onChanged: (value) {},
              controller: addressEditingController,
              maxLines: 2,
              decoration: const InputDecoration(
                helperText: 'Add The New Address',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async{
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              )
            ],
          );
        });
    userProvider.updateAddress( addressEditingController.text,context);
    addressEditingController.text;
    userProvider.userData.address = addressEditingController.text;
  }
}
