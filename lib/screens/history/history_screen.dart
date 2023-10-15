import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/history_model.dart';
import 'package:GroceryApp/allProviders/history_provider.dart';
import 'package:GroceryApp/screens/login_screen/login_screen.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../btm_bar_screen.dart';
import '../empty_screen/empty_screen.dart';
import 'history_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    List <HistoryModel> wishedItems = historyProvider.getHistoryItems.values.toList().reversed.toList();
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final User? user = FirebaseAuth.instance.currentUser;

    if (wishedItems.isEmpty) {
      return EmptyScreen(
            appBarTitle: 'Viewed Items',
            image: const Image(image: AssetImage('Assets/history.png')),
            title: user != null ? '" No Viewed Items "' : 'Sign in to view your history',
            buttonTitle: user != null ?'Browse Now':'Sign In Now',
            page: user != null ? const BottomBar():const LoginScreen(),
          );
    } else {
      return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: color,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      historyProvider.clearHistory();
                    },
                    icon: Icon(Icons.delete_outline_rounded,
                        color: themeState.getDarkTheme
                            ? Colors.white
                            : Colors.black))
              ],
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                'Viewed items',
                style: TextStyle(
                    color:
                        themeState.getDarkTheme ? Colors.white : Colors.black),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: wishedItems.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: wishedItems[index],
                            child: const HistoryWidget());
                      }),
                ),
              ],
            ));
    }
  }
}
