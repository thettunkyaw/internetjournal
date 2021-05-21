// Dart: Existing Libraries
import 'dart:convert';

// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries (Dependencies)
import 'package:shared_preferences/shared_preferences.dart';

// Models
import '../models/article.model.dart';

// FavoriteProvider Helper Class
class FavoriteProvider extends ChangeNotifier {
  // Class Properties
  List<ArticleModel> articleModelList = new List<ArticleModel>();

  // Getters Methods
  List<ArticleModel> getArticleModelList() {
    // if(this.articleModelList.length > 0)
    // print(
    //   "[favorite.provider.dart: 21] \n ${this.articleModelList[0].id}",
    // );
    return this.articleModelList.toList();
  }

  // Future Class Methods
  // Future<void> getNews() async {
  //   // this.notifyListeners();
  // }

  // Normal Class Methods
  void addInfo(ArticleModel articleModel) {
    this.articleModelList.add(articleModel);
    this.notifyListeners();
  }

  void removeInfo(ArticleModel articleModel) {
    this.articleModelList.remove(articleModel);
    this.notifyListeners();
  }

  bool isContain(ArticleModel articleModel) {
    int isContain;

    if (this.articleModelList.length > 0) {
      isContain = this
          .articleModelList
          .indexWhere((element) => element.title == articleModel.title);

      if (isContain != -1) {
        return true;
      } else {
        return false;
      }
      // this.notifyListeners();
    }

    // print("[favorite.provider.dart: 45] => The value of isContain is $isContain",);
    // this.notifyListeners();
    return false;
  }

  bool hasFavorite() {
    this.restore();
    return this.articleModelList.length == 0 ? false: true;
  }

  void saved() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(
      "favorite",
      this
          .articleModelList
          .map(
            (e) => json.encode(e),
          )
          .toList(),
    );
    List<String> stringList = sharedPreferences.getStringList("favorite");
    print("[favorite.provider.dart: 58] => The favorite is:");
    print(stringList);
    this.notifyListeners();
  }

  void restore() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList("favorite") != null) {
      List<dynamic> stringList = sharedPreferences.getStringList("favorite");
      List<ArticleModel> cacheArticleModel = new List<ArticleModel>();
      for (String string in stringList) {
        Map map = json.decode(string);
        ArticleModel articleModel = ArticleModel.fromJson(map);
        cacheArticleModel.add(articleModel);
      }
      this.articleModelList = cacheArticleModel;
      print(
        "[favorite.provider.dart: 75] => The articleModelList length is ${this.articleModelList.length}.",
      );
      this.notifyListeners();
    }
  }
}
