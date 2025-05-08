import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/products/service/product_service.dart';

class HomeModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductService _productService = ProductService();

  Stream<List<Product>> getLatestProducts() {
    return _productService.getProducts();
  }
}
