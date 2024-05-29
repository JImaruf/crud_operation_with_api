
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../model/product_model.dart';



class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key, required this.product});

  final ProductModel product;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  late TextEditingController _nameTEController;
  late TextEditingController _unitpriceTEController;
  late TextEditingController _quantityTEController;
  late TextEditingController _totalpriceTEController;
  late TextEditingController _imageTEController;
  late TextEditingController _productcodeTEController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController = TextEditingController();
    _unitpriceTEController = TextEditingController();
    _quantityTEController = TextEditingController();
    _totalpriceTEController = TextEditingController();
    _productcodeTEController = TextEditingController();
    _imageTEController = TextEditingController();
    _nameTEController.text = widget.product.productName ?? '';
    _unitpriceTEController.text = widget.product.unitPrice ?? '';
    _quantityTEController.text = widget.product.quality ?? '';
    _totalpriceTEController.text = widget.product.totalPrice ?? '';
    _productcodeTEController.text = widget.product.productCode?? '';
    _imageTEController.text = widget.product.image?? '';
  }

  Future<void> _updateProduct() async {
    setState(() {
      updateProductInProgress = true;
    });

    Map<String, String> inputData = {
      "Img": _imageTEController.text,
      "ProductCode": _productcodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalpriceTEController.text,
      "UnitPrice": _unitpriceTEController.text,
    };
    String updateProductUrl =
        "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}";
    Uri uri = Uri.parse(updateProductUrl);

    try {
      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product has been updated")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Update Product Failed!! Please try again.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
    } finally {
      setState(() {
        updateProductInProgress = false;
      });
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
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text(
          "Update Items",
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
                        borderRadius: BorderRadius.circular(10)

                    ),
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
                        borderRadius: BorderRadius.circular(10)

                    ),
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
                        borderRadius: BorderRadius.circular(10)

                    ),
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
                        borderRadius: BorderRadius.circular(10)
                    ),
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
                  decoration:InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                    ),
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
                  visible: !updateProductInProgress,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text("Update"),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.blue),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProduct();
                        }
                      },
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
}
