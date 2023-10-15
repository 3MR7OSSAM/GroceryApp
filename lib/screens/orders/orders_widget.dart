import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:GroceryApp/Models/oredr_model.dart';
class OrdersWidget extends StatelessWidget {
  final OrderModel order;
  const OrdersWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date = order.orderDate.toDate();
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    final String formatted = formatter.format(date);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 10,
        shadowColor: Colors.black,
        child: ListTile(
          minVerticalPadding: 30,
          title:  Center(child: Text(order.productName)),
          subtitle: Column(
            children: [
              Text('${order.quantity} ${order.unit}'),
              Text(formatted,style: const TextStyle(fontSize: 12),)
            ],
          ),
          leading: FancyShimmerImage(
            imageUrl: order.imageUrl,
            width: 70,
            boxFit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
