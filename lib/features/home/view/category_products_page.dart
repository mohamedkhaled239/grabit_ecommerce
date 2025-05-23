import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/view/category_product_widget.dart';
import 'package:grabit_ecommerce/generated/l10n.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const CategoryProductsPage({Key? key, required this.categoryName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          final productStream =
              context.read<HomeController>().getLatestProducts();

          return StreamBuilder<List<Product>>(
            stream: productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No Products Found'));
              }
              // Filter products based on the selected category
              // Assuming categoryName is the name of the category you want to filter by
              // and that the product model has a categoryName field
              final currentLang = Localizations.localeOf(context).languageCode;

              final categoryProducts =
                  snapshot.data!
                      .where(
                        (product) =>
                            currentLang == 'ar'
                                ? product.categoryNameAr.toLowerCase().contains(
                                  categoryName.toLowerCase(),
                                )
                                : product.categoryNameEn.toLowerCase().contains(
                                      categoryName.toLowerCase(),
                                    ) ||
                                    product.categoryNameAr
                                        .toLowerCase()
                                        .contains(categoryName.toLowerCase()),
                      )
                      .toList();

              if (categoryProducts.isEmpty) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).No_products_found_in,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(' $categoryName', style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 10,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return CategoryProductsWidget(
                              product: categoryProducts[index],
                            );
                          }, childCount: categoryProducts.length),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
