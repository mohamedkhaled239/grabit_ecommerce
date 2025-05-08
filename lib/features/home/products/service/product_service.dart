import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';
import '../model/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firestore.collection('allproducts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

  Future<Product> getProductById(String id) async {
    final doc = await _firestore.collection('allproducts').doc(id).get();
    if (!doc.exists) throw Exception('Product not found');
    return Product.fromFirestore(doc);
  }

  Future<List<Product>> fetchRelatedProducts({
    required String categoryId,
    required String currentProductId,
    required String currentProductName,
    required double currentProductPrice,
    int limit = 4,
  }) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('allproducts')
              .where('categoryId', isEqualTo: categoryId)
              .where(FieldPath.documentId, isNotEqualTo: currentProductId)
              .limit(limit)
              .get();

      final products =
          querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();

      products.sort((a, b) {
        final similarityA = StringSimilarity.compareTwoStrings(
          a.getLocalizedTitle('en'), // or use current language
          currentProductName,
        );
        final similarityB = StringSimilarity.compareTwoStrings(
          b.getLocalizedTitle('en'),
          currentProductName,
        );
        final priceDiffA = (a.price - currentProductPrice).abs();
        final priceDiffB = (b.price - currentProductPrice).abs();

        return similarityB.compareTo(similarityA) != 0
            ? similarityB.compareTo(similarityA)
            : priceDiffA.compareTo(priceDiffB);
      });

      return products;
    } catch (e) {
      throw Exception('Failed to load related products: $e');
    }
  }

  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    await _firestore.collection('allproducts').doc(productId).update({
      'quantity': newQuantity,
    });
  }
}
