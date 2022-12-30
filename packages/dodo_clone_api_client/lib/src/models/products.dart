import 'package:dodo_clone_api_client/src/models/product/product.dart';

Products productsFromJson(Map<String, dynamic> str) => Products.fromJson(str);

class Products {
  final bool error;
  final String message;
  final List<Product> result;

  const Products({
    required this.error,
    required this.message,
    required this.result,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
        error: json['error'],
        message: json['message'],
        result: List.from((json['result'] as List<Map<String, dynamic>>)
            .map(Product.fromJson)),
      );
  }
}
