import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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

              _buildProductCategory(),
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

  Widget _buildProductCategory() {
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
          // add image svg
          SizedBox(width: 1.w),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 255, 253, 253),
                    //shawod
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
                        'assets/images/wishlist.svg',
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

              const SizedBox(width: 5),
              InkWell(
                onTap: () {
                  log("add to cart");
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 255, 253, 253),
                    //shawod
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

  void _navigateToProductDetails(BuildContext context) {}
}
