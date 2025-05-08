import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> loadWishlist() async {
    try {
      emit(WishlistLoading());

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final wishlistData =
            userDoc.data()?['wishlist'] as List<dynamic>? ?? [];

        final items =
            wishlistData
                .map(
                  (item) => WishlistItem.fromMap(item as Map<String, dynamic>),
                )
                .toList();

        emit(WishlistLoaded(items));
      } else {
        emit(WishlistLoaded([]));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> addToWishlist(WishlistItem item) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlist': FieldValue.arrayUnion([item.toMap()]),
      });

      loadWishlist();
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final wishlist = userDoc.data()?['wishlist'] as List<dynamic>? ?? [];

      final itemToRemove = wishlist.firstWhere(
        (item) => (item as Map<String, dynamic>)['id'] == itemId,
        orElse: () => null,
      );

      if (itemToRemove != null) {
        await _firestore.collection('users').doc(userId).update({
          'wishlist': FieldValue.arrayRemove([itemToRemove]),
        });
      }

      loadWishlist();
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}
