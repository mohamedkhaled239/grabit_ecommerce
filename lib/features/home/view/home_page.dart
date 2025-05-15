import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/model/home_model.dart';
import 'package:grabit_ecommerce/features/home/search/view/search_page.dart';
import 'package:grabit_ecommerce/features/home/view/category_products_page.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => HomeController(HomeModel()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<HomeController, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
              } else if (state is HomeLoaded) {
                return _HomePageContent(customId: state.customId);
              } else if (state is HomeError) {
                return Center(child: Text(state.message, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error)));
              }
              return Center(child: Text('Unknown state', style: theme.textTheme.bodyLarge));
            },
          ),
        ),
      ),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  final String customId;

  const _HomePageContent({required this.customId});

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Clothing', 'image': 'assets/images/bread.svg'},
    {'title': 'Electronics', 'image': 'assets/images/corn.svg'},
    {'title': 'Home & Kitchen', 'image': 'assets/images/hamburger-soda.svg'},
    {'title': 'Snack & Spice', 'image': 'assets/images/french-fries.svg'},
    {'title': 'Dairy & Milk', 'image': 'assets/images/coffee-pot.svg'},
    {'title': 'Seafood', 'image': 'assets/images/shrimp.svg'},
    {'title': 'Food', 'image': 'assets/images/popcorn.svg'},
    {'title': 'Eggs', 'image': 'assets/images/egg.svg'},
  ];

  // final List<Map<String, dynamic>> categories = const [
  //   {'title': 'Bakery', 'image': 'assets/images/bread.svg'},
  //   {'title': 'vegetables', 'image': 'assets/images/corn.svg'},
  //   {'title': 'Juice & Drinks', 'image': 'assets/images/hamburger-soda.svg'},
  //   {'title': 'Snack & Spice', 'image': 'assets/images/french-fries.svg'},
  //   {'title': 'Dairy & Milk', 'image': 'assets/images/coffee-pot.svg'},
  //   {'title': 'Seafood', 'image': 'assets/images/shrimp.svg'},
  //   {'title': 'Fast Food', 'image': 'assets/images/popcorn.svg'},
  //   {'title': 'Eggs', 'image': 'assets/images/egg.svg'},
  // ];

  final List<Widget> banners = const [
    _BannerCard(image: 'assets/images/1.jpg'),
    _BannerCard(image: 'assets/images/2.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SearchBar(),
          _buildCategorySection(),
          _buildDealsSection(),
          _buildLastArrivalSection(),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return SizedBox(
      height: 13.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((category) => CategoryItem(
          title: category['title'],
          image: category['image'],
          onTap: () {},
        )).toList(),
      ),
    );
  }

  Widget _buildDealsSection() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            height: 23.h,
            child: Swiper(
              itemCount: banners.length,
              itemBuilder: (_, index) => banners[index],
              autoplay: true,
              autoplayDelay: 4000,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  color: Colors.white,
                  activeColor: Theme.of(context).colorScheme.primary,
                  size: 8.0,
                  activeSize: 10.0,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildLastArrivalSection() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                'Day of The Deals',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const LeastArrivalWidget(),
          ],
        );
      }
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String image;

  const _BannerCard({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.fitWidth),
      ),
      alignment: Alignment.center,
      child: Image.asset(image),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.title,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(categoryName: title),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Column(
          children: [
            SvgPicture.asset(
              color: theme.colorScheme.primary,
              image,
              width: 15.w,
              placeholderBuilder: (BuildContext context) => Container(
                width: 15.w,
                height: 15.w,
                color: theme.colorScheme.surface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: Container(
          height: 7.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              SizedBox(width: 1.w),
              Text(
                "  Search Products...",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              SizedBox(width: 3.w),
            ],
          ),
        ),
      ),
    );
  }
}
