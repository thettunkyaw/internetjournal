// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Constants
import '../constants/theme.constant.dart';

// Flutter: External Libraries
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  bool _isDark = false;

  ThemeData get getThemeData => this._themeData;

  bool get getDarkBoolValue => this._isDark;

  set setThemeData(ThemeData themeData) {
    this._themeData = themeData;
    this.notifyListeners();
  }

  set setDarkBoolValue(bool isDark) {
    this._isDark = isDark;
    this.notifyListeners();
  }

  void setSharedPreferencesValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("Theme") == "Light" ||
        sharedPreferences.getString("Theme") == null) {
      this._themeData = lightTheme;
      this._isDark = false;
    } else {
      this._themeData = darkTheme;
      this._isDark = true;
    }
    this.notifyListeners();

    return ;
  }
}
