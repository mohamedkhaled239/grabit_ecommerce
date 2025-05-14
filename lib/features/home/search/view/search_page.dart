import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_product_card.dart';
import 'package:grabit_ecommerce/generated/l10n.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    final productsStream = context.read<HomeController>().getLatestProducts();
    productsStream.first.then((products) {
      setState(() {
        _allProducts = products;
      });
    });
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results =
        _allProducts.where((product) {
          final titleLower = product.title.en.toLowerCase();
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower);
        }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 3.w),
                    const Icon(Icons.search, color: Color(0xff8391A1)),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: S.of(context).Search_Products,
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: const Color(0xff8391A1),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16.sp, color: Colors.black),
                        onChanged: _searchProducts,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xff8391A1)),
                        onPressed: () {
                          _searchController.clear();
                          _searchProducts('');
                        },
                      ),
                    SizedBox(width: 3.w),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  _searchResults.isEmpty && _searchController.text.isNotEmpty
                      ? Center(
                        child: Text(
                          S.of(context).No_products_found,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 2.h,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: LeastArrivalProductCard(
                              product: _searchResults[index],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
