import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/screens/cart/cart_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Models/cart_model.dart';
import '../../allProviders/cart_provider.dart';
import '../../allProviders/order_provider.dart';
import '../../allProviders/product_provider.dart';
import 'Payment_failure.dart';
import 'payment_success.dart';
import '../../shared/components/constants.dart';

class VisaCardScreen extends StatefulWidget {

  const VisaCardScreen({super.key});

  @override
  State<VisaCardScreen> createState() => _VisaCardScreenState();
}

class _VisaCardScreenState extends State<VisaCardScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  int loadingProgress = 0;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    List<CartModel> cartItems =
        cartProvider.getCartItems.values.toList().reversed.toList();
    //double totalPrice = 0.0;
    return Scaffold(
      body: WebView(
        initialUrl:
            'https://accept.paymob.com/api/acceptance/iframes/421887?payment_token=$FinalTokenCard',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          //print('WebView is loading (progress : $progress%)');
          loadingProgress = progress;
        },
        javascriptChannels: <JavascriptChannel>{
          _statusJavascriptChannel(context),
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            ////print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          //print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          if (url.contains('Approved')) {
            //print('Order Approved');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovedPayment(isVisa: false,)));
            // ignore: avoid_function_literals_in_foreach_calls
            cartItems.forEach((element) {
              final currentProduct =
              productProvider.findByID(element.productID);
              String price = double.parse(currentProduct.salePrice) == 0.0
                  ? currentProduct.price
                  : currentProduct.salePrice;
              //totalPrice = double.parse(price) * element.quantity;
              orderProvider.addOrder(
                productId: currentProduct.id,
                price: price,
                totalPrice: double.parse(price) * element.quantity,
                quantity: element.quantity,
                imageUrl: currentProduct.imageUrl,
                context: context,
                productName: currentProduct.title,
                unit: currentProduct.unit, paymentOption: 'Credit Card',
              );
            });
            orderProvider.fetchOrders(context);
            cartProvider.clearCart(context);
          } else if(url.contains('1&txn_')) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const FailurePayment()));
          }
        },
        onPageFinished: (String url) async {
          //print('Page finished loading: $url');

        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
      ),
      floatingActionButton: ExitButton(),
    );
  }

  JavascriptChannel _statusJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Status',
        onMessageReceived: (JavascriptMessage message) {
          String status = message.message;
          if (status == 'success') {
            //print('success');
          } else {
            //print('fail');
          }
        });
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  // ignore: non_constant_identifier_names
  Widget ExitButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return FloatingActionButton(
            onPressed: () {
              //print("nooo");
              Exit(context);
            },
            child: const Icon(Icons.exit_to_app),
          );
        });
  }

  Exit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Are You sure want to exit the visa card screen ?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              child: const Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No")),
        ],
      ),
    );
  }
}
