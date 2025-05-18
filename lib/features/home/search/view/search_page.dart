// features/home/search/view/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/products/model/product_model.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_product_card.dart';
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

    final results = _allProducts.where((product) {
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
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withOpacity(0.2),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search Products...",
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                        onChanged: _searchProducts,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _searchProducts('');
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                      child: Text(
                        'No products found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
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
