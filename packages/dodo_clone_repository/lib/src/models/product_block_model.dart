// import 'package:dodo_clone_api_client/dodo_clone_api_client.dart'
//     as dodo_clone_api_client;
// import 'models.dart';
//
// class ProductBlock {
//   final Section category;
//   final List<Product> products;
//
//   static const empty = ProductBlock(
//     category: Section(id: -1, categoryName: ''),
//     products: [],
//   );
//
//   const ProductBlock({
//     required this.category,
//     required this.products,
//   });
//
//   factory ProductBlock.fromApiClient(
//       dodo_clone_api_client.ProductsBlock productBlock,
//       List<Section> categories) {
//     return ProductBlock(
//       category: Section(
//         id: productBlock.categoryId,
//         categoryName: categories
//             .firstWhere((c) => c.id == productBlock.categoryId)
//             .categoryName,
//       ),
//       products: productBlock.products.map(Product.fromApiClient).toList(),
//     );
//   }
// }
//
// extension AllProducts on List<ProductBlock> {
//   List<Product> get allProducts {
//     final listProducts = <Product>[];
//     for (final k in this) {
//       listProducts.addAll(k.products);
//     }
//     return listProducts;
//   }
// }
