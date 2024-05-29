class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quality;
  String? totalPrice;

  ProductModel.fromjson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    productName = json['ProductName'] ?? '';
    productCode = json['ProductCode'] ?? '';
    image = json['Img'] ?? '';
    unitPrice = json['UnitPrice'] ?? '';
    quality = json['Qty'] ?? " ";
    totalPrice = json['TotalPrice'] ?? '';
  }
}