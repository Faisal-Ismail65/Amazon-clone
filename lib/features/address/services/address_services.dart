import 'dart:convert';
import 'package:amazon_flutter/constants/error_handling.dart';
import 'package:amazon_flutter/constants/global_variables.dart';
import 'package:amazon_flutter/constants/utils.dart';
import 'package:amazon_flutter/models/user.dart';
import 'package:amazon_flutter/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  // ddd product
  void saveUserAddress({
    required String address,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'address': address,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          User user = userProvider.user
              .copyWith(address: jsonDecode(response.body)['address']);

          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/order'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalSum,
        }),
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Your Order has been Placed!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
