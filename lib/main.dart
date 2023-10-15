import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/consts/theme_data.dart';
import 'package:GroceryApp/allProviders/DarkThemeProvider.dart';
import 'package:GroceryApp/allProviders/cart_provider.dart';
import 'package:GroceryApp/allProviders/history_provider.dart';
import 'package:GroceryApp/allProviders/order_provider.dart';
import 'package:GroceryApp/allProviders/product_provider.dart';
import 'package:GroceryApp/allProviders/userProvider.dart';
import 'package:GroceryApp/allProviders/wishlist_provider.dart';
import 'package:GroceryApp/allProviders/payment_provider.dart';
import 'package:GroceryApp/shared/network/dio.dart';
import 'package:GroceryApp/screens/feeds_screen/featch_screen.dart';

void main() async{
  await DioHelperPayment.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = true;

  DarkThemeProvider ThemeProvider = DarkThemeProvider();

  void getTheme() async {
    ThemeProvider.setDarkTheme = await ThemeProvider.DarkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator(),),),);
          }else if(snapshot.hasError){
            return const MaterialApp(home: Scaffold(body: Center(child: Text('There is an error'),),),);
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return ThemeProvider;
              }),
              ChangeNotifierProvider(create: (_) {
                return PaymentProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return UserProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return WishListProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return HistoryProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return ProductProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return CartProvider();
              }),
              ChangeNotifierProvider(create: (_) {
                return OrderProvider();
              }),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, ThemeProvider, child) {
                return MaterialApp(
                  theme: Styles.themeData(ThemeProvider.getDarkTheme, context),
                  debugShowCheckedModeBanner: false,
                  title: 'Flutter Demo',
                  home:  const fetchScreen(),
                );
              },
            ),
          );
        });
  }
}
