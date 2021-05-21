// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:shared_preferences/shared_preferences.dart';

// FontSizeProvider Provider Class
class FontSizeProvider extends ChangeNotifier {
  double _fontSize = 20;

  double get getFontSize => this._fontSize;

  set setFontSize(double fontSize) {
    this._fontSize = fontSize;
    this.notifyListeners();
  }

  void setSharedPreferencesValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int fontSize = (sharedPreferences.getInt("FontSize") == null) ? 20 : sharedPreferences.getInt("FontSize");
    this._fontSize = fontSize.toDouble();
    this.notifyListeners();

    return ;
  }
}