// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bot_toast/bot_toast.dart';

// Models
import '../models/article.model.dart';

// Pages
import './link.page.dart';
import './settings.page.dart';
import './favorite.page.dart';

// Providers
import '../providers/font_size.provider.dart';
import '../providers/theme.provider.dart';
import '../providers/favorite.provider.dart';

// ArticlePage StatelessWidget Class
class ArticlePage extends StatefulWidget {
  // Static Class Properties
  static String routeName = "/article-page";
  // Final Properties
  // final String imageUrl;
  // final String title;
  // final String description;
  // final String articleLink;

  // ArticlePage({
  //   @required this.title,
  //   @required this.description,
  //   @required this.imageUrl,
  //   @required this.articleLink,
  // });
  // Constructor
  // ArticlePage(Key key) : super(key: UniqueKey());
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  // Normal Class Properties
  final ScrollController _scrollController = new ScrollController();
  bool _isTop = true;

  // Lifecycle Hook Methods
  @override
  void initState() {
    super.initState();
    this._scrollController.addListener(
          this._scrollListener,
        );
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  // Normal Class Methods
  void _scrollListener() {
    if (this._scrollController.offset == 0.0) {
      setState(() {
        this._isTop = true;
      });
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

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Properties
    ArticleModel arguments = ModalRoute.of(context).settings.arguments;
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    bool isDark = themeProvider.getDarkBoolValue;
    bool isContain = favoriteProvider.isContain(arguments);

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
            tooltip: "Go To Settings",
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (this._isTop == false)
            FloatingActionButton(
              child: Icon(
                Icons.arrow_upward_rounded,
              ),
              onPressed: this._onTap,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          15.0,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: this._scrollController,
            // physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: arguments.imageLink,
                    placeholder: (context, url) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 50,
                      ),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 5.0,
                    right: 10.0,
                    bottom: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        // width: double.infinity - 10,
                        child: Text(
                          arguments.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: fontSizeProvider.getFontSize,
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            // horizontal: 5.0,
                            ),
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          alignment: Alignment.topCenter,
                          icon: Icon(
                            (isContain) ? Icons.star : Icons.star_outline,
                            size: 30.0,
                            color: Color(
                              0xffffD700,
                            ),
                          ),
                          onPressed: () {
                            if (isContain) {
                              favoriteProvider.removeInfo(arguments);
                              BotToast.showText(
                                text: "Successfully Removed!",
                              );
                            } else {
                              favoriteProvider.addInfo(arguments);
                              BotToast.showText(
                                text: "Successfully Added!",
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 5.0,
                    //     // left: 200.0,
                    //     right: 230.0,
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(
                    //       10.0,
                    //     ),
                    //     child: FittedBox(
                    //       child: Container(
                    //         alignment: Alignment.centerRight,
                    //         color: (isDark) ? Colors.white : Colors.black,
                    //         padding: EdgeInsets.symmetric(
                    //           horizontal: 10.0,
                    //           vertical: 10.0,
                    //         ),
                    //         child: Text(
                    //           "Date: " + arguments.date,
                    //           textAlign: TextAlign.right,
                    //           style: TextStyle(
                    //             color: (isDark) ? Colors.black : Colors.white,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      child: FittedBox(
                        child: Container(
                          alignment: Alignment.centerRight,
                          color: (isDark) ? Colors.white : Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            "Category: " + arguments.categoryName,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: (isDark) ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      child: FittedBox(
                        child: Container(
                          alignment: Alignment.centerRight,
                          color: (isDark) ? Colors.white : Colors.black,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            "Date: " + arguments.date,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: (isDark) ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    // left: 10.0,
                    top: 5.0,
                    right: 10.0,
                    bottom: 10.0,
                  ),
                  child: Html(
                    data: arguments.content.split("»»»")[0],
                    shrinkWrap: true,
                    onLinkTap: (String internalUrl) {
                      Navigator.pushNamed(
                        context,
                        LinkPage.routeName,
                        arguments: internalUrl,
                      );
                    },
                    style: {
                      "body": Style(
                        fontSize: FontSize(
                          fontSizeProvider.getFontSize - 5,
                        ),
                      ),
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Website Link",
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          launch(
                            arguments.articleLink,
                          );
                        },
                        child: Text(
                          arguments.articleLink,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
