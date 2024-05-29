import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late TextEditingController _nameTEController;
  late TextEditingController _unitpriceTEController;
  late TextEditingController _quantityTEController;
  late TextEditingController _totalpriceTEController;
  late TextEditingController _imageTEController;
  late TextEditingController _productcodeTEController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController = TextEditingController();
    _unitpriceTEController = TextEditingController();
    _quantityTEController = TextEditingController();
    _totalpriceTEController = TextEditingController();
    _imageTEController = TextEditingController();
    _productcodeTEController = TextEditingController();
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameTEController.text;
      final String unitPrice = _unitpriceTEController.text;
      final String quantity = _quantityTEController.text;
      final String totalPrice = _totalpriceTEController.text;
      final String image = _imageTEController.text;

      final response = await http.post(
        Uri.parse(
            'https://example.com/api/products'), // Replace with your API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'unitPrice': unitPrice,
          'quantity': quantity,
          'totalPrice': totalPrice,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _unitpriceTEController.dispose();
    _quantityTEController.dispose();
    _totalpriceTEController.dispose();
    _imageTEController.dispose();
    _productcodeTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: const Text(
          "Add Items",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _nameTEController,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)

                    ),
                    hintText: "Type Product Name",
                    label: Text("Name:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write your product name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _unitpriceTEController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    hintText: "Type Unit Price",
                    label: Text("Unit Price:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write unit price";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    hintText: "Type Quantity",
                    label: Text("Quantity:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write Quantity";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _totalpriceTEController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    hintText: "Type Total Price",
                    label: Text("Total Price:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write total price";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _productcodeTEController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    hintText: "Type Product Code",
                    label: Text("Product Code:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Write Product Code";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageTEController,
                  decoration:  InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),),
                    hintText: "Put Image",
                    label: Text("Image:"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Put the image";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _inProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addProductAPI();
                        }
                      },
                      child: const Text("Add Product"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange,foregroundColor: Colors.white,elevation: 5,shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProductAPI() async {
    _inProgress = true;
    setState(() {});
    const String addProductUrl =
        "https://crud.teamrabbil.com/api/v1/CreateProduct";
    Map<String, dynamic> inputData = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _productcodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalpriceTEController.text,
      "UnitPrice": _unitpriceTEController.text,
    };
    Uri uri = Uri.parse(addProductUrl);
    Response response = await post(
      uri,
      body: jsonEncode(inputData),
      headers: {'content-type': 'application/json'},
    );
    print(response.body);
    print(response.statusCode);
    print(response.headers);

    _inProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _nameTEController.clear();
      _unitpriceTEController.clear();
      _totalpriceTEController.clear();
      _productcodeTEController.clear();
      _imageTEController.clear();
      _quantityTEController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Product Added Successfully")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Adding new product failed! Try again.")));
    }
  }
}