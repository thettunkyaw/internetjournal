// Dart: Properties
import 'dart:convert';

// Flutter: External Libraries
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

// Models
import '../models/article.model.dart';
import '../models/category.model.dart';

// Helpers
import 'data.helper.dart';

// CategoryLoadMoreNewsHelper Helper Class
class CategoryLoadMoreNewsHelper {
  // Static Class Properties
  static int pageNumber = 2;
  // Normal Properties
  List<ArticleModel> _news = [];
  DataHelper dataHelper = new DataHelper();

  // Get Methods
  List<ArticleModel> get news {
    print("The news length is ${this._news.length}.");

    if (this._news.length == 0) {
      return [];
    }

    return this._news;
  }

  // Normal Methods
  Future<void> getNews(String categoryName) async {
    List<CategoryModel> categoryList = dataHelper.getCategoriesList
        .where((category) => category.cateogryName == categoryName)
        .toList();
    int categoryNumber = categoryList[0].categoryNumber;

    // Api Properties
    String url =
        "https://internetjournal.media/wp-json/wp/v2/posts?categories=$categoryNumber&_embed&per_page=20&page=${CategoryLoadMoreNewsHelper.pageNumber++}";
    print(url);
    var response = await http.get(url);
    print(response.statusCode);
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

      jsonData.forEach(
        (article) {
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
              : "Internet Journal News";
          ArticleModel articleModel = new ArticleModel(
            id: article["id"],
            // date: article["date"],
            date: dateString,
            // date: DateFormat("dd/MM/yy HH:mm").format(article["date"]),
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
        },
      );
    }
  }
}
