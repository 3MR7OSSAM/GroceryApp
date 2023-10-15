import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:GroceryApp/screens/checkout/payment_success.dart';

import '../../Models/cart_model.dart';
import '../../allProviders/DarkThemeProvider.dart';
import '../../allProviders/cart_provider.dart';
import '../../allProviders/order_provider.dart';
import '../../allProviders/product_provider.dart';
import '../../allProviders/userProvider.dart';
import '../../methods/btm_alert.dart';

class AddressConfirmation extends StatefulWidget {
  const AddressConfirmation({Key? key}) : super(key: key);

  @override
  State<AddressConfirmation> createState() => _AddressConfirmationState();
}

class _AddressConfirmationState extends State<AddressConfirmation> {
  final TextEditingController _addressTextController = TextEditingController();
  String? address;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.returnData();
    final orderProvider = Provider.of<OrderProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    List<CartModel> cartItems =
        cartProvider.getCartItems.values.toList().reversed.toList();
    _addressTextController.text = userData.address!;
    final themeState = Provider.of<DarkThemeProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(height * 0.02),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                          )),
                      const Spacer(
                        flex: 1,
                      ),
                      const Text(
                        'Delivery Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.10,
                ),
                Image.asset('Assets/checckout/address.png'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                  child: TextFormField(
                    controller: _addressTextController,
                    onChanged: (value) {
                      if (_addressTextController.text != value) {
                        _addressTextController.text = value;
                      }
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.blueAccent, width: 1),
                      ),
                      hintText: "What is your address",
                      prefixIcon: const Icon(Icons.location_city_rounded),
                    ),
                  ),
                ),
                // const Expanded(child: SizedBox(),),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: height * 0.02, vertical: height * 0.03),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                      child: Container(
                        color: Colors.blue,
                        width: double.infinity,
                        height: height * 0.07,
                        child: const Center(
                          child: Text(
                            'Confirm Address',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          userProvider.updateAddress(
                              _addressTextController.text, context);
                          cartItems.forEach((element) {
                            final currentProduct =
                                productProvider.findByID(element.productID);
                            String price =
                                double.parse(currentProduct.salePrice) == 0.0
                                    ? currentProduct.price
                                    : currentProduct.salePrice;
                            orderProvider.addOrder(
                              productId: currentProduct.id,
                              price: price,
                              totalPrice:
                                  double.parse(price) * element.quantity,
                              quantity: element.quantity,
                              imageUrl: currentProduct.imageUrl,
                              context: context,
                              productName: currentProduct.title,
                              unit: currentProduct.unit,
                              paymentOption: 'Cash on Delivery',
                            );
                          });
                          setState(() {
                            _isLoading = false;
                          });
                          orderProvider.fetchOrders(context);
                          cartProvider.clearCart(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ApprovedPayment(
                                        isVisa: false,
                                      )));
                        } on Exception catch (e) {
                          setState(() {
                            _isLoading = false;
                            showBtmAlert(context, e.toString());
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
