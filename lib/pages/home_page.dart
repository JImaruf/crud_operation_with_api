import 'dart:convert';

import 'package:crud_app_api/pages/update.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../model/product_model.dart';
import 'add_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _getinprogress = false;
  List<ProductModel> productList = [];

  @override
  void initState() {
    super.initState();
    _getlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade100,
        title: const Text(
          "Home Page",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _getlist,
        child: Visibility(
          visible: !_getinprogress,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (_, __) => const Divider(),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                if(productList.length<1)
                  {
                    return Center(child: Text("No Product Available"));
                  }
                else
                  {return _buildProductItem(productList[index]);}

              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade500,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  Future<void> _getlist() async {
    setState(() {
      _getinprogress = true;
    });

    const String productListUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productListUrl);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final jsonProductList = decodedData['data'] as List;

      List<ProductModel> tempList = [];
      for (Map<String, dynamic> json in jsonProductList) {
        ProductModel productModel = ProductModel.fromjson(json);
        tempList.add(productModel);
      }
      setState(() {
        productList = tempList.cast<ProductModel>();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Get failed! Try again."),
        ),
      );
    }

    setState(() {
      _getinprogress = false;
    });
  }

  ListTile _buildProductItem(ProductModel product) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.orange.shade200,
      leading: Image.network(
        product.image.toString(),
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      ),
      title: Text(
        product.productName ?? '',
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Wrap(
        spacing: 16,
        children: [
          Text("Unit Price: \$${product.unitPrice}"),
          Text("Quantity: ${product.quality}"),
          Text("Total Price: ${product.totalPrice}"),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProduct(
                    product: product,
                  ),
                ),
              );
              if (result == true) {
                _getlist();
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(product.id!);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure to delete?'),
          actions: [
            TextButton.icon(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete,color: Colors.red,),
              label: const Text('Delete'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel_outlined,color: Colors.green,),
              label: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String productId) async {
    setState(() {
      _getinprogress = true;
    });

    String deleteProductUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    Uri uri = Uri.parse(deleteProductUrl);
    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      _getlist();
    } else {
      _getinprogress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Delete Product failed! Try again."),
        ),
      );
    }
  }
}