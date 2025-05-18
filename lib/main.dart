import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grabit_ecommerce/features/auth/controller/auth_controller.dart';
import 'package:grabit_ecommerce/features/auth/controller/auth_state.dart';
import 'package:grabit_ecommerce/features/auth/controller/register_controller.dart';
import 'package:grabit_ecommerce/features/auth/model/auth_model.dart';
import 'package:grabit_ecommerce/features/auth/model/register_model.dart';
import 'package:grabit_ecommerce/features/auth/view/login_page.dart';
import 'package:grabit_ecommerce/features/auth/view/register_page.dart';
import 'package:grabit_ecommerce/features/cart/view/cart_screen.dart';
import 'package:grabit_ecommerce/features/home/controller/home_controller.dart';
import 'package:grabit_ecommerce/features/home/model/home_model.dart';
import 'package:grabit_ecommerce/features/home/search/view/search_page.dart';
import 'package:grabit_ecommerce/features/home/view/home_page.dart';
import 'package:grabit_ecommerce/features/home/view/least_arrival_widget.dart';
import 'package:grabit_ecommerce/features/root_screen.dart';
import 'package:grabit_ecommerce/features/cart/controller/cart_cubit.dart';
import 'package:grabit_ecommerce/features/wishlist/controller/wishlist_cubit.dart';
import 'package:grabit_ecommerce/features/theme/controller/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthController(AuthModel())),
        BlocProvider(create: (context) => RegisterController(RegisterModel())),
        BlocProvider(
          create: (context) => HomeController(HomeModel()),
          child: const LeastArrivalWidget(),
        ),
        BlocProvider(
          create: (_) => CartCubit(FirebaseAuth.instance.currentUser!.uid),
          child: CartScreen(),
        ),
        BlocProvider(
          create: (_) {
            final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
            return WishlistCubit(userId)..loadWishlist();
          },
        ),
        BlocProvider(create: (_) => ThemeCubit(prefs)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 1,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.grey[900],
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[900],
                elevation: 1,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            themeMode: themeCubit.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomePage(),
              '/root': (context) => const RootScreen(),
              '/search': (context) => const SearchPage(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return const RootScreen();
        }
        return const LoginPage();
      },
    );
  }
}
