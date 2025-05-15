import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/wishlist_item_model.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}

class WishlistCubit extends Cubit<WishlistState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  WishlistCubit(this.userId) : super(WishlistInitial()) {
    loadWishlist();
  }

  List<WishlistItem> _items = [];

  static WishlistCubit createWithCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return WishlistCubit(user.uid);
  }

  Future<void> loadWishlist() async {
    try {
      emit(WishlistLoading());

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final wishlistData =
            userDoc.data()?['wishlist'] as List<dynamic>? ?? [];

        _items =
            wishlistData
                .map(
                  (item) => WishlistItem.fromMap(item as Map<String, dynamic>),
                )
                .toList();

        emit(WishlistLoaded(List.from(_items)));
      } else {
        _items = [];
        emit(WishlistLoaded([]));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> addToWishlist(WishlistItem item) async {
    try {
      if (_items.any((element) => element.id == item.id)) return;

      _items.add(item);

      await _firestore.collection('users').doc(userId).set({
        'wishlist': _items.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true));

      emit(WishlistLoaded(List.from(_items)));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    try {
      _items.removeWhere((element) => element.id == itemId);

      await _firestore.collection('users').doc(userId).set({
        'wishlist': _items.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true));

      emit(WishlistLoaded(List.from(_items)));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  void clearWishlist() {
    _items.clear();
    emit(WishlistLoaded([]));
  }
}
