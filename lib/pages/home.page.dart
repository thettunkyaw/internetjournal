// Dart: Properties
import 'dart:convert';
import 'dart:async';

// Flutter: Existing Libraries
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loadmore/loadmore.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Models
import '../models/article.model.dart';

// Helpers
import '../helpers/data.helper.dart';
import '../helpers/news.helper.dart';
import '../helpers/load_more_news.helper.dart';

// Pages
import './settings.page.dart';
import './splash.page.dart';
import './internet_connection_lost.page.dart';
import './favorite.page.dart';

// Widgets
import '../widgets/category_tile.widget.dart';
import '../widgets/standard.widget.dart';
import '../widgets/text_only.widget.dart';
import '../widgets/image_only.widget.dart';

// Providers
import '../providers/layout.provider.dart';
import '../providers/theme.provider.dart';
import '../providers/favorite.provider.dart';

// HomePage StatefulWidget Class
class HomePage extends StatefulWidget {
  // Static Class Properties
  static String routeName = "/";
  static bool isFirstTime = true;
  @override
  _HomePageState createState() => _HomePageState();
}

// _HomePageState State Class
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // Normal Properties
  DataHelper _dataHelper = new DataHelper();
  NewsHelper _newsHelper = new NewsHelper();
  List<ArticleModel> _articles = new List<ArticleModel>();
  bool _loading = true;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  DateTime currentBackPressTime;
  StreamSubscription<ConnectivityResult> _streamSubscriptionConnectivityResult;
  bool _isActiveOnline = true;
  bool _isTop = true;
  double _categorySpaceHeight = 75;
  int count = 0;

  // Final Properties
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Connectivity _connectivity = new Connectivity();
  final ScrollController _scrollController = new ScrollController();

  // Lifecycle Hooks Methods
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    this._streamSubscriptionConnectivityResult = this
        ._connectivity
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      print("The connectivityResult is $connectivityResult.");
      if (connectivityResult == ConnectivityResult.none) {
        setState(() {
          this._isActiveOnline = false;
        });
      } else {
        setState(() {
          this._isActiveOnline = true;
        });
      }

      if (this._isActiveOnline) {
        print("IT is now active");
        this.getNews();
      } else {
        print("it is not active");
        this.setSharedPreferencesValue();
      }
    });
    print("Is it top: ${this._isTop}");
    this.getNews();

    this.initializing();
    this.flutterLocalNotificationsPlugin.cancelAll();

    this._dataHelper = DataHelper();
    // this.getNews();
    this._scrollController.addListener(
          this._scrollListener,
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    if (state == AppLifecycleState.resumed) {
      favoriteProvider.restore();
      // this.flutterLocalNotificationsPlugin.cancelAll();
    }

    if (state == AppLifecycleState.inactive) {
      favoriteProvider.saved();
      // this._showNotificationsAfterFewSeconds();
    }
  }

  // Normal Methods
  void setSharedPreferencesValue() async {
    print(
      "[home.page.dart: 130] => It is in setSharedPreferencesValue",
    );
    print(this._isActiveOnline);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(
      context,
      listen: false,
    );
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Case 001
    // Do not need favorite information
    if (sharedPreferences.getStringList("home-data") == null &&
        this._isActiveOnline == false &&
        HomePage.isFirstTime == false) {
      print("This is case 001! [false, false, false]");
      setState(() {
        this._loading = true;
      });
    }
    // Case 002
    // Do not need favorite information
    else if (sharedPreferences.getStringList("home-data") == null &&
        this._isActiveOnline == false &&
        HomePage.isFirstTime == true) {
      print("This is case 002! [false, false, true]");
      Future.delayed(
          Duration(
            seconds: 3,
          ), () {
        setState(() {
          this._loading = true;
          HomePage.isFirstTime = false;
        });
      });
    }
    // Case 003
    // Need to saved favorite information
    else if (sharedPreferences.getStringList("home-data") == null &&
        this._isActiveOnline == true &&
        HomePage.isFirstTime == false) {
      print("This is case 003! [false, true, false]");
      favoriteProvider.restore();
      favoriteProvider.saved();
      await sharedPreferences.setStringList(
        "home-data",
        this
            ._articles
            .map(
              (e) => json.encode(e),
            )
            .toList(),
      );
      setState(() {
        this._loading = false;
      });
    }
    // Case 004
    // Need to restore favorite information
    else if (sharedPreferences.getStringList("home-data") == null &&
        this._isActiveOnline == true &&
        HomePage.isFirstTime == true) {
      print("This is case 004! [false, true, true]");
      favoriteProvider.restore();
      favoriteProvider.saved();
      await sharedPreferences.setStringList(
        "home-data",
        this
            ._articles
            .map(
              (e) => json.encode(e),
            )
            .toList(),
      );

      Future.delayed(
        Duration(
          seconds: 3,
        ),
        () {
          setState(
            () {
              this._loading = false;
              HomePage.isFirstTime = false;
            },
          );
        },
      );
    }
    // case 005
    // Need to restore favorite information
    else if (sharedPreferences.getStringList("home-data") != null &&
        this._isActiveOnline == false &&
        HomePage.isFirstTime == false) {
      print("This is case 005! [true, false, false]");
      favoriteProvider.restore();
      favoriteProvider.saved();
      List<dynamic> stringList = sharedPreferences.getStringList("home-data");
      List<ArticleModel> cacheArticleModel = new List<ArticleModel>();
      for (String string in stringList) {
        Map map = json.decode(string);
        ArticleModel articleModel = ArticleModel.fromJson(map);
        cacheArticleModel.add(articleModel);
      }
      // print(cacheArticleModel[0].categoryName);
      print("The cacheArticleModel length is ");
      print(cacheArticleModel.length);
      setState(() {
        this._articles = cacheArticleModel;
      });

      Future.delayed(
        Duration(
          seconds: 3,
        ),
        () {
          setState(() {
            this._loading = false;
          });
        },
      );
    }

    // case 006
    // Need to restore favorite information
    else if (sharedPreferences.getStringList("home-data") != null &&
        this._isActiveOnline == false &&
        HomePage.isFirstTime == true) {
      print("This is case 006! [true, false, true]");
      favoriteProvider.restore();
      favoriteProvider.saved();
      List<dynamic> stringList = sharedPreferences.getStringList("home-data");
      List<ArticleModel> cacheArticleModel = new List<ArticleModel>();
      for (String string in stringList) {
        Map map = json.decode(string);
        ArticleModel articleModel = ArticleModel.fromJson(map);
        cacheArticleModel.add(articleModel);
      }
      // print(cacheArticleModel[0].categoryName);
      setState(() {
        this._articles = cacheArticleModel;
      });

      Future.delayed(
        Duration(
          seconds: 3,
        ),
        () {
          setState(() {
            this._loading = false;
            HomePage.isFirstTime = false;
          });
        },
      );
    }
    // Case 007
    // Need to save favorite information
    else if (sharedPreferences.getStringList("home-data") != null &&
        this._isActiveOnline == true &&
        HomePage.isFirstTime == false) {
      print("This is case 007! [true, true, false]");
      favoriteProvider.restore();
      await sharedPreferences.setStringList(
        "home-data",
        this
            ._articles
            .map(
              (e) => json.encode(e),
            )
            .toList(),
      );
      if (this._articles.length == 0) {
        this.getNews();
      }
      setState(() {
        this._loading = false;
      });
    }
    // Case 008
    // Need to restore the favorite information
    else if (sharedPreferences.getStringList("home-data") != null &&
        this._isActiveOnline == true &&
        HomePage.isFirstTime == true) {
      print("This is case 008! [true, true, true]");
      favoriteProvider.restore();
      await sharedPreferences.setStringList(
        "home-data",
        this
            ._articles
            .map(
              (e) => json.encode(e),
            )
            .toList(),
      );
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          this._loading = false;
          HomePage.isFirstTime = false;
        });
      });
    }
  }

  void _scrollListener() {
    if (this._scrollController.offset == 0.0) {
      setState(() {
        this._isTop = true;
      });
      this.getNews();
    } else {
      setState(() {
        this._isTop = false;
      });
    }
  }

  Future<void> initializing() async {
    this.androidInitializationSettings =
        AndroidInitializationSettings('internet_journal_light_theme_logo');
    this.iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    this.initializationSettings = InitializationSettings(
      this.androidInitializationSettings,
      this.iosInitializationSettings,
    );
    await this.flutterLocalNotificationsPlugin.initialize(
          this.initializationSettings,
          onSelectNotification: onSelectNotification,
        );
  }

  void _showNotificationsAfterFewSeconds() async {
    await this.notificationAfterFewSeconds();
  }

  Future<void> notificationAfterFewSeconds() async {
    // Properties
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Second_Channel_Id',
      'Second_Channel_Title',
      'Second_Channel_Body',
      priority: Priority.High,
      importance: Importance.Max,
      ticker: 'ticker',
    );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationsDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );

    // ignore: deprecated_member_use
    this.flutterLocalNotificationsPlugin.showDailyAtTime(
          0,
          'Internet Journal',
          'နောက်ဆုံးရ IT သတင်းမျ���းကို Internet Journal တွင်ဖတ်ရှုလိုက်ပါ',
          new Time(07, 00, 00),
          notificationsDetails,
        );
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
    // We can see navigator to navigate another screen
  }

  Future<Widget> onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            'Okay',
          ),
          onPressed: () {
            print('');
          },
        ),
      ],
    );
  }

  // Normal Methods
  void getNews() async {
    print("getNews()");
    print(this._isActiveOnline);
    if (this._isActiveOnline) {
      this._newsHelper = NewsHelper();
      await this._newsHelper.getNews();
      this._articles = this._newsHelper.news;
      this.setSharedPreferencesValue();
      setState(() {
        this._loading = false;
      });
    } else {
      print("It is in else state");
      this.setSharedPreferencesValue();
    }
  }

  void _onTap() {
    this.count = 1;
    LoadMoreNewsHelper.pageNumber = 2;

    print(this.count);
    print(LoadMoreNewsHelper.pageNumber);

    this._scrollController.animateTo(
          0,
          duration: Duration(
            milliseconds: 500,
          ),
          curve: Curves.easeInOut,
        );
  }

  // Future Methods
  Future<bool> _onWillPop() async {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  favoriteProvider.saved();
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    LoadMoreNewsHelper loadMoreNewsHelper = new LoadMoreNewsHelper();
    await loadMoreNewsHelper.getNews();
    List<ArticleModel> loadMoreArticleList = loadMoreNewsHelper.news;
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

  // Build Method
  @override
  Widget build(BuildContext context) {
    LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    if (size.height >= 1000) {
      setState(() {
        this._categorySpaceHeight = 120;
      });
    } else {
      setState(() {
        this._categorySpaceHeight = 75;
      });
    }

    bool isDark = themeProvider.getDarkBoolValue;
    {
      // if (this._loading == true && HomePage.isFirstTime == true)
      if (this._loading == true && HomePage.isFirstTime == true) {
        this.setSharedPreferencesValue();
        return SplashPage();
      } else if (this._loading == true && HomePage.isFirstTime == false) {
        this.setSharedPreferencesValue();
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 100,
                  color: Colors.lightBlue,
                ),
                SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    "Please, check your internet connection.",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        setState(() {
          HomePage.isFirstTime = false;
        });
        return WillPopScope(
          onWillPop: this._onWillPop,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                child: Column(
                  children: [
                    Container(
                      height: this._categorySpaceHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: this._dataHelper.getCategoriesList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return CategoryTileWidget(
                            imageUrl: this
                                ._dataHelper
                                .getCategoriesList[index]
                                .imageUrl,
                            categoryName: this
                                ._dataHelper
                                .getCategoriesList[index]
                                .cateogryName,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // color: Colors.white,
                        width: double.infinity,
                        // height: double.infinity,
                        child: (this._articles.length == 0)
                            ? Container(
                                padding: const EdgeInsets.all(
                                  10.0,
                                ),
                                alignment: Alignment.center,
                                // child: Placeholder(),
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
                                  // physics: NeverScrollableScrollPhysics(),
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: this._articles.length + 1,
                                  itemBuilder: (context, index) {
                                    // print(count);
                                    // count++;
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5.0,
                                          bottom: 10.0,
                                        ),
                                        child: Text(
                                          "Latest News",
                                          style: TextStyle(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                    if (layoutProvider.getLayoutOptions ==
                                        LayoutOptions.Standard) {
                                      count++;
                                      return StandardWidget(
                                        articleModel: this._articles[index - 1],
                                      );
                                    } else if (layoutProvider
                                            .getLayoutOptions ==
                                        LayoutOptions.TextOnly) {
                                      count++;
                                      return TextOnlyWidget(
                                        articleModel: this._articles[index - 1],
                                      );
                                    } else {
                                      count++;
                                      return ImageOnlyWidget(
                                        articleModel: this._articles[index - 1],
                                      );
                                    }
                                  },
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
