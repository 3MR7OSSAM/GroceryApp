import 'package:flutter/material.dart';
import 'package:GroceryApp/screens/checkout/visa_card.dart';
import '../Models/firstToken.dart';
import '../shared/components/constants.dart';
import '../shared/network/dio.dart';
class PaymentProvider extends ChangeNotifier {
  FirstToken? firstToken;
  Future<void> getFirstToken(double price, String firstName, String lastName,
      String email, String phone, context) async {
    //print("getFirstToken");
    try {
      final value = await DioHelperPayment.postData(
        url: 'auth/tokens',
        data: {'api_key': PaymobKey},
      );
      PaymobToken = value.data['token'];
      //print('first token : $PaymobToken');
      await getOrderId(price, firstName, lastName, email, phone, context);
    } catch (error) {
      //print("error");
      //print(error);
    }
  }

  Future getOrderId(double price, String firstName, String lastName,
      String email, String phone, context) async {
    //print("getOrderId");
    DioHelperPayment.postData(url: 'ecommerce/orders', data: {
      'auth_token': PaymobToken,
      'delivery_needed': 'false',
      "amount_cents": price,
      "currency": "EGP",
      "items": []
    }).then((value) {
      paymobOrderId = value.data['id'].toString();

      getFinalToken(price, firstName, lastName, email, phone,context);
    }).catchError((error) {

    });
  }

  Future<void> getFinalToken(double price, String firstName, String lastName,
      String email, String phone,context) async {
    //print("getFinalToken");
    try {
      final value = await DioHelperPayment.postData(
        url: 'acceptance/payment_keys',
        data: {
          "auth_token": PaymobToken,
          "amount_cents": price,
          "expiration": 3600,
          "order_id": paymobOrderId,
          "billing_data": {
            "apartment": "NA",
            "email": email,
            "floor": "NA",
            "first_name": firstName,
            "street": "NA",
            "building": "NA",
            "phone_number": phone,
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "last_name": lastName,
            "state": "NA"
          },
          "currency": "EGP",
          "integration_id": IntegrationIdCard,
          "lock_order_when_paid": "false"
        },
      );
      FinalTokenCard = value.data['token'].toString();
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const VisaCardScreen()));
      //print('FinalTokenCard : ${FinalTokenCard}');
    } catch (error) {
      //print("error");
      //print(error);
    }
  }
}