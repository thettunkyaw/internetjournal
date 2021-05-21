// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:shared_preferences/shared_preferences.dart';

enum LayoutOptions {
  Standard,
  TextOnly,
  ImageOnly,
}

class LayoutProvider extends ChangeNotifier {
  LayoutOptions _option = LayoutOptions.Standard;

  LayoutOptions get getLayoutOptions => this._option;

  set setLayoutOptions(LayoutOptions layoutOption) {
    this._option = layoutOption;
    this.notifyListeners();
  }

  void setSharedPreferencesValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String layout = sharedPreferences.getString("Layout");

    if(layout == "Standard" || layout == null) {
      this._option = LayoutOptions.Standard;
    } else if(layout == "TextOnly") {
      this._option = LayoutOptions.TextOnly;
    } else {
      this._option = LayoutOptions.ImageOnly;
    }
    this.notifyListeners();
    
    return ;
  }
}