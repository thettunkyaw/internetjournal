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

// NewsHelper Helper Class
class NewsHelper {
  // Normal Properties
  List<ArticleModel> _news = [];
  DataHelper dataHelper = new DataHelper();

  // Get Methods
  List<ArticleModel> get news {
    return this._news;
  }

  // Normal Methods
  Future<void> getNews() async {
    // Api Properties
    String url =
        "https://internetjournal.media/wp-json/wp/v2/posts?_embed&per_page=20";
    var response = await http.get(url);
    // var fetchFile;
    // var res;
    // FileInfo fileInfo = await DefaultCacheManager().getFileFromCache(url);
    // if (fileInfo.file == null) {
    //   fetchFile = await DefaultCacheManager().getSingleFile(url);
    //   res = await fetchFile.readAsString();
    // } else {
    //   res = await fileInfo.file.readAsString();
    // }
    // print(response.body);
    var jsonData = jsonDecode(
      response.body,
      // res,
    );

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
