import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/products_model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/product_provider.dart';
import 'on_sala_widget.dart';

class onSaleScreen extends StatelessWidget {
  const onSaleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<ProductModel> onSaleProducts = productProvider.onSale;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        centerTitle: true,
        title: Text(
          'Sales',
          style: TextStyle(color: color),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: onSaleProducts.isEmpty ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('Assets/box.png'),width: 80,),
          SizedBox(height: 10,),
          Center(child: Text('No Sales Yet !\n  Stay Turned',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),

        ],
      ) : GridView.builder(
        shrinkWrap: true,
        itemCount: onSaleProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ChangeNotifierProvider.value(
                value: onSaleProducts[index],
                child: const OnSale()),
          );
        },
      ),
    );
  }
}
