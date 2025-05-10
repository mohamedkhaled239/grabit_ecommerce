import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_state.dart';
import 'package:grabit_ecommerce/features/cart/model/cart_item_model.dart';

class CartCubit extends Cubit<CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  CartCubit(this.userId) : super(CartInitial()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      emit(CartLoading());

      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('cart')
              .get();

      final items =
          snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();

      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> addToCart(CartItem item) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.id)
          .set(item.toMap());

      loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .delete();

      loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .update({'quantity': newQuantity});

      loadCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  double get subtotal {
    if (state is! CartLoaded) return 0;
    return (state as CartLoaded).items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get vat => subtotal * 0.2;
  double get total => subtotal + vat;
}
