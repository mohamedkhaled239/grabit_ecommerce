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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grabit_ecommerce/core/theme/theme_cubit.dart';
import 'package:grabit_ecommerce/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    final prefs = await SharedPreferences.getInstance();
    runApp(MyApp(prefs: prefs));
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app: $e'),
        ),
      ),
    ));
  }
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
          create: (_) => CartCubit(FirebaseAuth.instance.currentUser?.uid ?? ''),
          child: CartScreen(),
        ),
        BlocProvider(
          create: (_) {
            final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
            return WishlistCubit(userId)..loadWishlist();
          },
        ),
        BlocProvider(
          create: (_) => ThemeCubit(prefs),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDarkMode = state is ThemeLoaded ? state.isDarkMode : false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
