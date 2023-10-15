import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../allProviders/DarkThemeProvider.dart';
class PriceWidget extends StatelessWidget {
  const PriceWidget({Key? key, required this.salePrice, required this.price, required this.textPrice, required this.isOnSale}) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    double userPrice = isOnSale? salePrice : price;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Row(
      children: [
    Text(
      '${(userPrice * double.parse(textPrice)).toStringAsFixed(2)} EGP',
     style: const TextStyle(
       color: Colors.green,
       fontSize: 16
     ),
    ),
    const SizedBox(
      width: 5,
    ),
    Visibility(
      visible: isOnSale? true :false,
      child: Text(
        (price * int.parse(textPrice)).toStringAsFixed(2),
        style: TextStyle(
          fontSize: 11,
          color: color,
          decoration: TextDecoration.lineThrough,
        ),
      ),
    )
      ],
    );
  }
}
