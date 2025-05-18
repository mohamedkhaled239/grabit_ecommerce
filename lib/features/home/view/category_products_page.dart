import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/view/category_product_widget.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const CategoryProductsPage({Key? key, required this.categoryName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 0,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          final productStream =
              context.read<HomeController>().getLatestProducts();

          return StreamBuilder<List<Product>>(
            stream: productStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No Products Found',
                    style: theme.textTheme.bodyLarge,
                  ),
                );
              }

              final categoryProducts =
                  snapshot.data!
                      .where(
                        (product) => product.categoryName
                            .toLowerCase()
                            .contains(categoryName.toLowerCase()),
                      )
                      .toList();

              if (categoryProducts.isEmpty) {
                return Center(
                  child: Text(
                    'No products found in $categoryName',
                    style: TextStyle(fontSize: 16.sp),
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
