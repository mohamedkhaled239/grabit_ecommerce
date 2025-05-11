import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_cubit.dart';
import 'package:grabit_ecommerce/features/cart/model/cart_item_model.dart';
import 'package:grabit_ecommerce/features/wishlist/controller/wishlist_cubit.dart';
import 'package:grabit_ecommerce/features/wishlist/model/wishlist_item_model.dart';

class CategoryProductsWidget extends StatelessWidget {
  final Product product;

  const CategoryProductsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToProductDetails(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 35.w,

                      color: Colors.grey[100],
                      child: CachedNetworkImage(
                        imageUrl: product.mainImage,
                        fit: BoxFit.fill,
                        placeholder:
                            (context, url) => Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Center(
                              child: Icon(Icons.error, color: Colors.grey[400]),
                            ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: BlocBuilder<WishlistCubit, WishlistState>(
                      builder: (context, state) {
                        bool isInWishlist =
                            state is WishlistLoaded &&
                            state.items.any((item) => item.id == product.id);
                        return GestureDetector(
                          onTap: () => _handleWishlist(context, isInWishlist),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite,
                              size: 18,
                              color:
                                  isInWishlist ? Colors.red : Colors.grey[400],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Product Title
              Text(
                product.title.en,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 0.5.h),

              // Product Category
              Text(
                product.categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 1.h),

              // Price and Add to Cart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5CAF90),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _addToCart(context),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5CAF90).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                        color: const Color(0xFF5CAF90),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleWishlist(BuildContext context, bool isInWishlist) {
    if (isInWishlist) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Already in wishlist')));
    } else {
      final wishlistCubit = context.read<WishlistCubit>();
      final wishlistItem = WishlistItem(
        id: product.id,
        name: product.title.en,
        imageUrl: product.mainImage,
        price: product.price,
      );
      wishlistCubit.addToWishlist(wishlistItem);
    }
  }

  void _addToCart(BuildContext context) {
    final cartItem = CartItem(
      id: product.id,
      productId: product.productId,
      name: product.title.en,
      imageUrl: product.mainImage,
      price: product.price,
      quantity: 1,
      categoryName: product.categoryName,
    );
    context.read<CartCubit>().addToCart(cartItem);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to cart!')));
  }

  void _navigateToProductDetails(BuildContext context) {
    // Implement navigation to product details
  }
}
