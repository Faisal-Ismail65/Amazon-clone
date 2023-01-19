import 'dart:convert';

import 'package:amazon_flutter/constants/error_handling.dart';
import 'package:amazon_flutter/constants/global_variables.dart';
import 'package:amazon_flutter/constants/utils.dart';
import 'package:amazon_flutter/models/order.dart';
import 'package:amazon_flutter/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
}
