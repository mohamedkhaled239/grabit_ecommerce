import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/model/home_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeController extends Cubit<HomeState> {
  final HomeModel _model;
  List<Product> _allProducts = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // define _firestore

  HomeController(this._model) : super(HomeInitial()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    emit(HomeLoading());
    try {
      await _model.getLatestProducts().first;
      emit(HomeLoaded('default-custom-id'));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Stream<List<Product>> getLatestProducts() {
    return _firestore
        .collection('allproducts')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) {
          print('Received ${snapshot.docs.length} products from Firestore');
          return snapshot.docs
              .map((doc) {
                print('Processing product ${doc.id}');
                try {
                  return Product.fromFirestore(doc);
                } catch (e, stack) {
                  print('Error parsing document ${doc.id}: $e');
                  print(stack);
                  return null;
                }
              })
              .where((product) => product != null)
              .cast<Product>()
              .toList();
        });
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    return _allProducts.where((product) {
      final titleLower = product.title.en.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();
  }

  Stream<List<Product>> getProductsByCategory(
    String categoryName,
    BuildContext context,
  ) {
    final languageCode = Localizations.localeOf(context).languageCode;

    return _model.getLatestProducts().map((products) {
      return products.where((product) {
        final productCategoryName =
            languageCode == 'ar'
                ? product.categoryNameAr
                : product.categoryNameEn;

        return productCategoryName.toLowerCase() == categoryName.toLowerCase();
      }).toList();
    });
  }
}
