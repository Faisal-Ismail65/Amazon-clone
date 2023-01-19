// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_flutter/models/product.dart';

class Order {
  final String id;
  final List<Product> product;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderetAt;
  final int status;
  final double totalPrice;
  Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderetAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderetAt': orderetAt,
      'status': status,
      'totalPrice': totalPrice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? ' ',
      product: List<Product>.from(
        map['product']?.map(
          (x) => Product.fromMap(
            x['product'],
          ),
        ),
      ),
      quantity: List<int>.from(
        map['product']?.map(
          (x) => x['quantity'],
        ),
      ),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderetAt: map['orderetAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
