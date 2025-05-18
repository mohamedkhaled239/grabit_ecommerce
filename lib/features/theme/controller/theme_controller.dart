import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme States
abstract class ThemeState {}

class ThemeInitial extends ThemeState {
  final bool isDarkMode;
  ThemeInitial(this.isDarkMode);
}

class ThemeChanged extends ThemeState {
  final bool isDarkMode;
  ThemeChanged(this.isDarkMode);
}

// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'isDarkMode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs) : super(ThemeInitial(_prefs.getBool(_themeKey) ?? false));

  bool get isDarkMode {
    if (state is ThemeInitial) {
      return (state as ThemeInitial).isDarkMode;
    } else if (state is ThemeChanged) {
      return (state as ThemeChanged).isDarkMode;
    }
    return false;
  }

  Future<void> toggleTheme() async {
    final newValue = !isDarkMode;
    await _prefs.setBool(_themeKey, newValue);
    emit(ThemeChanged(newValue));
  }
} 