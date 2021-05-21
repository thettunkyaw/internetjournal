// Dart: Properties
import 'dart:async';
import 'dart:convert';

// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loadmore/loadmore.dart';

// Models
import '../models/article.model.dart';

// Helpers
import '../helpers/category_news.helper.dart';
import '../helpers/category_load_more_news.helper.dart';

// Pages
import './settings.page.dart';
import './favorite.page.dart';

// Widgets
import '../widgets/standard.widget.dart';
import '../widgets/text_only.widget.dart';
import '../widgets/image_only.widget.dart';

// Providers
import '../providers/layout.provider.dart';
import '../providers/theme.provider.dart';

// CategoryPage StatefulWidget Class
class CategoryPage extends StatefulWidget with WidgetsBindingObserver {
  // Static Class Properties
  static String routeName = "/category-page";

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

// _CategoryPageState State Class
class _CategoryPageState extends State<CategoryPage> {
  // Final Properties
  final Connectivity _connectivity = new Connectivity();
  final ScrollController _scrollController = new ScrollController();

  // Normal Properties
  String categoryName = "";
  bool _isActiveOnline = false;
  StreamSubscription<ConnectivityResult> _streamSubscriptionConnectivityresult;
  List<ArticleModel> _articles;
  bool _loading = true;
  bool _isTop = true;
  int count = 0;

  // Lifecycle Hooks Methods
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        this.getCategoryNews();
      },
    );

    this._scrollController.addListener(
          this._scrollListener,
        );
    super.initState();
  }

  // Normal Methods
  void setSharedPreferencesValue() async {
    print(
      "[category.page.dart: 98] => It is in setSharedPreferencesValue",
    );
    setState(
      () {
        this.categoryName = ModalRoute.of(context).settings.arguments;
      },
    );
    print(this._isActiveOnline);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList(this.categoryName + "-data") == null &&
        this._isActiveOnline == true) {
      print(
        "case 01",
      );
      // var value = jsonEncode(this._articles.toList());
      // var value = this._articles.toString();
      await sharedPreferences.setStringList(
          this.categoryName + "-data",
          this
              ._articles
              .map(
                (e) => json.encode(e),
              )
              .toList());
    } else if (sharedPreferences.getStringList(this.categoryName + "-data") !=
            null &&
        this._isActiveOnline == true) {
      print(
        "[category.page.dart: 125] => case 02",
      );
      await sharedPreferences.setStringList(
          this.categoryName + "-data",
          this
              ._articles
              .map(
                (e) => json.encode(e),
              )
              .toList());
    } else if (sharedPreferences.getStringList(this.categoryName + "-data") !=
            null &&
        this._isActiveOnline == false) {
      print(
        "[category.page.dart: 138] => case 03",
      );
      // print(sharedPreferences.getStringList(this.categoryName+"-data"));
      List<dynamic> stringList =
          sharedPreferences.getStringList(this.categoryName + "-data");
      List<ArticleModel> cacheArticleModel = new List<ArticleModel>();
      for (String string in stringList) {
        Map map = json.decode(string);
        ArticleModel articleModel = ArticleModel.fromJson(map);
        cacheArticleModel.add(articleModel);
      }
      print(cacheArticleModel[0].categoryName);
      setState(() {
        this._articles = cacheArticleModel;
        Future.delayed(
          Duration(
            seconds: 3,
          ),
          () {
            this._loading = false;
          },
        );
      });
    }
  }

  void _scrollListener() {
    if (this._scrollController.offset == 0.0) {
      setState(() {
        this._isTop = true;
      });
      this.getCategoryNews();
    } else {
      setState(() {
        this._isTop = false;
      });
    }
  }

  void _onTap() {
    this._scrollController.animateTo(
          0,
          duration: Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
        );
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    CategoryLoadMoreNewsHelper categoryLoadMoreNewsHelper =
        new CategoryLoadMoreNewsHelper();
    await categoryLoadMoreNewsHelper.getNews(this.categoryName);
    final loadMoreArticleList = categoryLoadMoreNewsHelper.news;
    if (loadMoreArticleList[0].id != null) {
      print(loadMoreArticleList[0].id);
      print("LoadMoreArticleList Length is ${loadMoreArticleList.length}");
      setState(() {
        this._articles.addAll(loadMoreArticleList.toList());
      });
      print("The articles model length is ${this._articles.length}");
    } else {
      return false;
    }

    return true;
  }

  void getCategoryNews() async {
    // CategoryLoadMoreNewsHelper.pageNumber = 2;
    setState(
      () {
        this.categoryName = ModalRoute.of(context).settings.arguments;
      },
    );
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        this._isActiveOnline = false;
      });
      print(
        "[category.page.dart: 85] => Is it active online: ${this._isActiveOnline}",
      );
      this.setSharedPreferencesValue();
    } else {
      setState(() {
        this._isActiveOnline = true;
      });
      print(
        "[category.page.dart: 85] => Is it active online: ${this._isActiveOnline}",
      );

      CategoryNewsHelper categoryNewsHelper = new CategoryNewsHelper();
      await categoryNewsHelper.getNews(this.categoryName);
      this._articles = categoryNewsHelper.news;
      this.setSharedPreferencesValue();
      setState(() {
        this._loading = false;
      });
    }
  }

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Properties
    LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.getDarkBoolValue;

    // if (this._isActiveOnline == false) {
    //   return InternetConnectionLost();
    // } else {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (isDark)
            ? Image.asset(
                "assets/images/internet_journal_dark_logo.png",
                width: 100,
                height: 50,
              )
            : Image.asset(
                "assets/images/internet_journal_image_with_text.png",
                width: 100,
                height: 50,
              ),
        actions: [
          IconButton(
            tooltip: "Go to Favorites",
            icon: const Icon(
              Icons.star,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                FavoritePage.routeName,
              );
            },
          ),
          IconButton(
            tooltip: "Go to Settings",
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                SettingsPage.routeName,
              );
            },
          ),
        ],
      ),
      floatingActionButton: (this._isTop == false)
          ? FloatingActionButton(
              child: Icon(
                Icons.arrow_upward_rounded,
              ),
              onPressed: this._onTap,
            )
          : null,
      body: (this._loading == true)
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  // mainAxisSize: MainAxisSize.min,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  child: (this._articles.length == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(
                            10.0,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : LoadMore(
                          isFinish: count == this._articles.length,
                          onLoadMore: this._loadMore,
                          textBuilder: DefaultLoadMoreTextBuilder.english,
                          child: ListView.builder(
                            controller: this._scrollController,
                            shrinkWrap: true,
                            itemCount: this._articles.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              count++;
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5.0,
                                    bottom: 10.0,
                                  ),
                                  child: Text(
                                    this.categoryName + " News",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              } else {
                                if (layoutProvider.getLayoutOptions ==
                                    LayoutOptions.Standard) {
                                  return StandardWidget(
                                    articleModel: this._articles[index - 1],
                                  );
                                } else if (layoutProvider.getLayoutOptions ==
                                    LayoutOptions.TextOnly) {
                                  return TextOnlyWidget(
                                    articleModel: this._articles[index - 1],
                                  );
                                } else {
                                  return ImageOnlyWidget(
                                    articleModel: this._articles[index - 1],
                                  );
                                }
                              }
                            },
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
