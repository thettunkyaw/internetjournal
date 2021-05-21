// Dart: Properties
import 'dart:convert';

// Flutter: External Libraries
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Pages
import '../pages/home.page.dart';

// Models
import '../models/article.model.dart';
import '../models/category.model.dart';

// Helpers
import './data.helper.dart';

// LoadMoreNewsHelper Helper Class
class LoadMoreNewsHelper {
  // Static Helper Properties
  static int pageNumber = 2;
  // Normal Properties
  List<ArticleModel> _news = [];
  DataHelper dataHelper = new DataHelper();

  // Get Methods
  List<ArticleModel> get news {
    return this._news;
  }

  // Normal Methods
  Future<void> getNews() async {
    print("I'm now in load_more_news_helper.dart");
    print(pageNumber);
    // Api Properties
    String url =
        "https://internetjournal.media/wp-json/wp/v2/posts?_embed&per_page=20&page=${pageNumber++}";
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 400) {
      print("Hello");
      ArticleModel articleModel = new ArticleModel(
        id: null,
        date: null,
        title: null,
        description: null,
        content: null,
        imageLink: null,
        articleLink: null,
        categoryName: null,
      );
      this._news.add(articleModel);
    } else {
      var jsonData = jsonDecode(
        response.body,
      );
      // print(jsonData);
      jsonData.forEach(
        (article) {
          if (!article["categories"].contains(178)) {
            DateTime dateTime = DateTime.parse(article["date"]);
            String dateString = dateTime.day.toString() +
                "/" +
                dateTime.month.toString() +
                "/" +
                dateTime.year.toString();
            List<CategoryModel> categoryModelList = dataHelper.getCategoriesList
                .where((CategoryModel categoryModel) =>
                    categoryModel.categoryNumber == article["categories"][0])
                .toList();
            CategoryModel categoryModelForCategoryName =
                (categoryModelList.length > 0) ? categoryModelList[0] : null;

            String categoryName = (categoryModelForCategoryName != null)
                ? categoryModelForCategoryName.cateogryName + " News"
                : "IJ News";
            ArticleModel articleModel = new ArticleModel(
              id: article["id"],
              date: dateString,
              title: article["title"]["rendered"],
              description: article["excerpt"]["rendered"],
              content: article["content"]["rendered"],
              imageLink: ((article["_embedded"]["wp:featuredmedia"] != null) &&
                      (article["_embedded"]["wp:featuredmedia"][0]
                              ["source_url"] !=
                          null) &&
                      (article["_embedded"]["wp:featuredmedia"][0]
                              ["source_url"] !=
                          ""))
                  ? (article["_embedded"]["wp:featuredmedia"][0]["source_url"])
                  : "https://internetjournal.media/wp-content/uploads/2019/08/ij-logo2.png",
              articleLink: article["link"],
              categoryName: categoryName,
            );
            this._news.add(articleModel);
          }
        },
      );
    }
  }
}
