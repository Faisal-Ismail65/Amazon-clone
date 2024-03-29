// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:amazon_flutter/constants/error_handling.dart';
import 'package:amazon_flutter/constants/global_variables.dart';
import 'package:amazon_flutter/constants/utils.dart';
import 'package:amazon_flutter/features/auth/screens/auth_screen.dart';
import 'package:amazon_flutter/models/order.dart';
import 'package:amazon_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    List<Order> orderList = [];
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(response.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(response.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString('x-auth-token', '');
      Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
