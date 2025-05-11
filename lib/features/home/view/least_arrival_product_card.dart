import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_cubit.dart';
import 'package:grabit_ecommerce/features/cart/model/cart_item_model.dart';
import 'package:grabit_ecommerce/features/wishlist/controller/wishlist_cubit.dart';
import 'package:grabit_ecommerce/features/wishlist/model/wishlist_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grabit_ecommerce/features/home/view/product_details_page.dart';

class LeastArrivalProductCard extends StatelessWidget {
  final Product product;

  const LeastArrivalProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToProductDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(color: Colors.grey, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
              _buildProductImage(),
              SizedBox(height: 2.h),
              Divider(color: Colors.black, thickness: 0.5),

              _buildProductCategory(context),
              SizedBox(height: 1.h),
              _buildProductTitle(),
              SizedBox(height: 1.h),

              _buildProductPrice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3.w),
      child: Container(
        width: double.infinity,
        height: 45.w,
        color: Colors.white,
        child: CachedNetworkImage(
          imageUrl: product.mainImage,
          fit: BoxFit.contain,
          placeholder:
              (context, url) => const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              ),
          errorWidget:
              (context, url, error) =>
                  Center(child: Image.asset('assets/images/placeholder.png')),
        ),
      ),
    );
  }

  Widget _buildProductCategory(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.categoryName,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  bool isInWishlist = false;
                  if (state is WishlistLoaded) {
                    isInWishlist = state.items.any(
                      (item) => item.id == product.id,
                    );
                  }
                  return IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isInWishlist ? Colors.red : Colors.grey,
                    ),
                    onPressed:
                        isInWishlist
                            ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Already exists')),
                              );
                            }
                            : () {
                              final wishlistCubit =
                                  BlocProvider.of<WishlistCubit>(
                                    context,
                                    listen: false,
                                  );
                              final userId =
                                  FirebaseAuth.instance.currentUser?.uid ?? '';
                              final wishlistItem = WishlistItem(
                                id: product.id,
                                name: product.title.en,
                                imageUrl: product.mainImage,
                                price: product.price,
                              );
                              wishlistCubit.addToWishlist(wishlistItem);
                            },
                  );
                },
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () {
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

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart!')),
                  );
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 255, 253, 253),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/images/cart.svg',
                        color: Colors.black.withOpacity(0.5),
                        placeholderBuilder:
                            (BuildContext context) => Container(
                              width: 12,
                              height: 12,
                              color: Colors.grey[300],
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductPrice() {
    return Center(
      child: Text(
        "\$${product.price}",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    return Center(
      child: Text(
        product.title.en,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }
}
