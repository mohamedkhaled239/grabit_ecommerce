// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// ` Home`
  String get Home {
    return Intl.message(' Home', name: 'Home', desc: '', args: []);
  }

  /// `Wishlist`
  String get Wishlist {
    return Intl.message('Wishlist', name: 'Wishlist', desc: '', args: []);
  }

  /// `Cart`
  String get Cart {
    return Intl.message('Cart', name: 'Cart', desc: '', args: []);
  }

  /// `Profile`
  String get Profile {
    return Intl.message('Profile', name: 'Profile', desc: '', args: []);
  }

  /// `Day of The Deals`
  String get Day_of_The_Deals {
    return Intl.message(
      'Day of The Deals',
      name: 'Day_of_The_Deals',
      desc: '',
      args: [],
    );
  }

  /// `Search Products...`
  String get Search_Products {
    return Intl.message(
      'Search Products...',
      name: 'Search_Products',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get Clothing {
    return Intl.message('Clothing', name: 'Clothing', desc: '', args: []);
  }

  /// `Electronics`
  String get Electronics {
    return Intl.message('Electronics', name: 'Electronics', desc: '', args: []);
  }

  /// `Food`
  String get Food {
    return Intl.message('Food', name: 'Food', desc: '', args: []);
  }

  /// `SeaFood`
  String get SeaFood {
    return Intl.message('SeaFood', name: 'SeaFood', desc: '', args: []);
  }

  /// `Dairy & Milk`
  String get Dairy_Milk {
    return Intl.message('Dairy & Milk', name: 'Dairy_Milk', desc: '', args: []);
  }

  /// `Snacks & Spices`
  String get Snack_Spices {
    return Intl.message(
      'Snacks & Spices',
      name: 'Snack_Spices',
      desc: '',
      args: [],
    );
  }

  /// `Eggs`
  String get Eggs {
    return Intl.message('Eggs', name: 'Eggs', desc: '', args: []);
  }

  /// `Subtotal:`
  String get Subtotal {
    return Intl.message('Subtotal:', name: 'Subtotal', desc: '', args: []);
  }

  /// `Your cart is empty`
  String get Cart_is_empty {
    return Intl.message(
      'Your cart is empty',
      name: 'Cart_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `VAT (20%):`
  String get VAT {
    return Intl.message('VAT (20%):', name: 'VAT', desc: '', args: []);
  }

  /// `Total:`
  String get Total {
    return Intl.message('Total:', name: 'Total', desc: '', args: []);
  }

  /// `CHECKOUT`
  String get CHECKOUT {
    return Intl.message('CHECKOUT', name: 'CHECKOUT', desc: '', args: []);
  }

  /// `VIEW CART`
  String get VIEW_CART {
    return Intl.message('VIEW CART', name: 'VIEW_CART', desc: '', args: []);
  }

  /// `No user found`
  String get No_user_found {
    return Intl.message(
      'No user found',
      name: 'No_user_found',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get Logout {
    return Intl.message('Logout', name: 'Logout', desc: '', args: []);
  }

  /// `Your wishlist is empty`
  String get Your_wishlist_is_empty {
    return Intl.message(
      'Your wishlist is empty',
      name: 'Your_wishlist_is_empty',
      desc: '',
      args: [],
    );
  }

  /// `No products found in`
  String get No_products_found_in {
    return Intl.message(
      'No products found in',
      name: 'No_products_found_in',
      desc: '',
      args: [],
    );
  }

  /// `No products found`
  String get No_products_found {
    return Intl.message(
      'No products found',
      name: 'No_products_found',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message('Login', name: 'Login', desc: '', args: []);
  }

  /// `Don\'t have an account? `
  String get dont_have_an_account {
    return Intl.message(
      'Don\\\'t have an account? ',
      name: 'dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `  Sign Up`
  String get Sign_Up {
    return Intl.message('  Sign Up', name: 'Sign_Up', desc: '', args: []);
  }

  /// `Enter your email`
  String get Enter_your_email {
    return Intl.message(
      'Enter your email',
      name: 'Enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get Enter_your_password {
    return Intl.message(
      'Enter your password',
      name: 'Enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get Login_failed {
    return Intl.message(
      'Login failed',
      name: 'Login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message('Register', name: 'Register', desc: '', args: []);
  }

  /// `Enter your name`
  String get Enter_your_name {
    return Intl.message(
      'Enter your name',
      name: 'Enter_your_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone`
  String get Enter_your_phone {
    return Intl.message(
      'Enter your phone',
      name: 'Enter_your_phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter full name`
  String get Enter_your_full_name {
    return Intl.message(
      'Enter full name',
      name: 'Enter_your_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter  password confirmation`
  String get Enter_your_password_confirmation {
    return Intl.message(
      'Enter  password confirmation',
      name: 'Enter_your_password_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message('password', name: 'password', desc: '', args: []);
  }

  /// `email`
  String get email {
    return Intl.message('email', name: 'email', desc: '', args: []);
  }

  /// `Already have an account? Login`
  String get Already_have_account {
    return Intl.message(
      'Already have an account? Login',
      name: 'Already_have_account',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
