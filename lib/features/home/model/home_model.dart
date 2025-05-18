import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/products/service/product_service.dart';

class HomeModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductService productService = ProductService();

  Stream<List<Product>> getLatestProducts() {
    return _firestore
        .collection('allproducts')
        .orderBy('createdAt', descending: true)
        .limit(20) // Limit the number of products for performance
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Product.fromFirestore(doc))
              .toList();
        });
  }
}
