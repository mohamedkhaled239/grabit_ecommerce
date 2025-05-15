import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme states
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final bool isDarkMode;
  ThemeLoaded(this.isDarkMode);
}

// Theme cubit
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  ThemeCubit(this._prefs) : super(ThemeInitial()) {
    _loadTheme();
  }

  void _loadTheme() {
    try {
      final isDarkMode = _prefs.getBool(_themeKey) ?? false;
      emit(ThemeLoaded(isDarkMode));
    } catch (e) {
      emit(ThemeLoaded(false));
    }
  }

  Future<void> toggleTheme() async {
    try {
      if (state is ThemeLoaded) {
        final currentState = state as ThemeLoaded;
        final newThemeMode = !currentState.isDarkMode;
        await _prefs.setBool(_themeKey, newThemeMode);
        emit(ThemeLoaded(newThemeMode));
      }
    } catch (e) {
      // If there's an error, keep the current theme
      if (state is ThemeLoaded) {
        emit(ThemeLoaded((state as ThemeLoaded).isDarkMode));
      }
    }
  }

  bool get isDarkMode {
    if (state is ThemeLoaded) {
      return (state as ThemeLoaded).isDarkMode;
    }
    return false;
  }
} 