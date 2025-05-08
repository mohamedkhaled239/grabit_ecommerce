import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_product_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeastArrivalWidget extends StatelessWidget {
  const LeastArrivalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
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

            return Column(
              children: List.generate(
                snapshot.data!.length,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: SizedBox(
                    width: double.infinity,

                    child: LeastArrivalProductCard(
                      product: snapshot.data![index],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
