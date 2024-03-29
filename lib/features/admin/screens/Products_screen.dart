// ignore_for_file: file_names

import 'package:amazon_flutter/common/widgets/loader.dart';
import 'package:amazon_flutter/features/account/widgets/single_product.dart';
import 'package:amazon_flutter/features/admin/services/admin_service.dart';
import 'package:amazon_flutter/models/product.dart';
import 'package:flutter/material.dart';
import 'package:amazon_flutter/features/admin/screens/add_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product>? products;
  final AdminServices _adminServices = AdminServices();
  @override
  void initState() {
    fetchAllProducts();
    super.initState();
  }

  fetchAllProducts() async {
    products = await _adminServices.fetchAllProduct(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    _adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(
                          image: productData.images[0],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                productData.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => deleteProduct(productData, index),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              tooltip: 'Add a Product',
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
