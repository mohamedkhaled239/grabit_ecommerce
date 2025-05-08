import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/controller/home_state.dart';
import 'package:grabit_ecommerce/features/home/model/home_model.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeController(HomeModel()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<HomeController, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                return _HomePageContent(customId: state.customId);
              } else if (state is HomeError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Unknown state'));
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
    {'title': 'Bakery', 'image': 'assets/images/bread.svg'},
    {'title': 'vegetables', 'image': 'assets/images/corn.svg'},
    {'title': 'Juice & Drinks', 'image': 'assets/images/hamburger-soda.svg'},
    {'title': 'Snack & Spice', 'image': 'assets/images/french-fries.svg'},
    {'title': 'Dairy & Milk', 'image': 'assets/images/coffee-pot.svg'},
    {'title': 'Seafood', 'image': 'assets/images/shrimp.svg'},
    {'title': 'Fast Food', 'image': 'assets/images/popcorn.svg'},
    {'title': 'Eggs', 'image': 'assets/images/egg.svg'},
  ];

  final List<Widget> banners = const [
    _BannerCard(image: 'assets/images/1.jpg'),
    _BannerCard(image: 'assets/images/2.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
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
        children:
            categories
                .map(
                  (category) => CategoryItem(
                    title: category['title'],
                    image: category['image'],
                    onTap: () {},
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildDealsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SizedBox(
        height: 23.h,
        child: Swiper(
          itemCount: banners.length,
          itemBuilder: (_, index) => banners[index],
          autoplay: true,
          autoplayDelay: 4000,
          pagination: const SwiperPagination(
            alignment: Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.white,
              activeColor: Color(0xFF5CAF90),
              size: 8.0,
              activeSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastArrivalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: const Text(
            'Day of The Deals',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5CAF90),
            ),
          ),
        ),
        const LeastArrivalWidget(),
      ],
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: Column(
          children: [
            SvgPicture.asset(
              color: const Color(0xFF5CAF90),
              image,
              width: 15.w,
              placeholderBuilder:
                  (BuildContext context) => Container(
                    width: 15.w,
                    height: 15.w,
                    color: Colors.grey[300],
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 7.h,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1.0),
          ),
          child: Row(
            children: [
              SizedBox(width: 1.w),
              Text(
                "  Search Products...",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xff8391A1),
                ),
              ),
              const Spacer(),
              const Icon(Icons.search, color: Color(0xff8391A1)),
              SizedBox(width: 3.w),
            ],
          ),
        ),
      ),
    );
  }
}
