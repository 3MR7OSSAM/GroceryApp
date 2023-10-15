import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/Models/oredr_model.dart';

import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/order_provider.dart';
import '../../btm_bar_screen.dart';
import '../empty_screen/empty_screen.dart';
import 'orders_widget.dart';
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final List<OrderModel> orders = orderProvider.getOrders;
    final color = themeState.getDarkTheme ? Colors.white54 : Colors.black54;
    return orders.isEmpty ? const EmptyScreen(
      appBarTitle: 'Orders',
      image: Image(image: AssetImage('Assets/empty-list.png')), title: '" No orders yet "',buttonTitle:'Shop Now',page: BottomBar(),):Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: color,
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title:Text('Orders' ,style: TextStyle(color: themeState.getDarkTheme ? Colors.white : Colors.black),),
        ),
        body: ListView.separated(
            itemCount: orders.length,
             separatorBuilder: (BuildContext context, int index) {
              return Divider(
                indent: 60.0,
                endIndent: 60.0,
                color: color,
                thickness: 1,
              );
        }, itemBuilder: (BuildContext context, int index) {
          return OrdersWidget(order: orders[index],);
        },)
    );
  }
}
