import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/home/view/home_page.dart';
import 'package:grabit_ecommerce/features/cart/view/cart_screen.dart';
import 'package:grabit_ecommerce/features/wishlist/controller/wishlist_cubit.dart';
import 'package:grabit_ecommerce/features/wishlist/view/wishlist_screen.dart';
import 'package:grabit_ecommerce/features/profile/view/profile_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController controller;
  int currentScreen = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder:
          (context, orientation, screenType) => Scaffold(
            body: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const HomePage(),
                BlocProvider(
                  create: (_) => WishlistCubit.createWithCurrentUser(),
                  child: const WishlistScreen(),
                ),
                const CartScreen(),
                const ProfileScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentScreen,
              onTap: (index) {
                setState(() {
                  currentScreen = index;
                });
                controller.jumpToPage(currentScreen);
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFF5CAF90),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.home),
                  activeIcon: Icon(IconlyBold.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.heart),
                  activeIcon: Icon(IconlyBold.heart),
                  label: "Wishlist",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.bag),
                  activeIcon: Icon(IconlyBold.bag),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.profile),
                  activeIcon: Icon(IconlyBold.profile),
                  label: "Profile",
                ),
              ],
            ),
          ),
    );
  }
}
