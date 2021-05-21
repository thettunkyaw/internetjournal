// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';

// Models
import '../models/article.model.dart';

// Providers
import '../providers/theme.provider.dart';
import '../providers/favorite.provider.dart';
import '../providers/layout.provider.dart';

// Pages
import './settings.page.dart';

// Widgets
import '../widgets/standard.widget.dart';
import '../widgets/text_only.widget.dart';
import '../widgets/image_only.widget.dart';

// FavoritePage StatelessWidget Class
class FavoritePage extends StatefulWidget {
  // Static Final Class Properties
  static final String routeName = "/favorite";

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // Final Class Properties
  final ScrollController _scrollController = new ScrollController();

  // Normal Class Properties
  bool _isTop = true;

  // Lifecycle Hook Methods
  @override
  void initState() {
    super.initState();
    this._scrollController.addListener(
          this._scrollListener,
        );
  }

  // Normal Class Properties
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

  @override
  Widget build(BuildContext context) {
    // Normal Method Properties
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
    List<ArticleModel> articlesList = favoriteProvider.getArticleModelList();
    bool isDark = themeProvider.getDarkBoolValue;

    // Returning Widgets
    return SafeArea(
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
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            controller: this._scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    bottom: 10.0,
                  ),
                  child: Text(
                    (articlesList.length == 0) ? "" : "Favorite News",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                (articlesList.length == 0)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off_rounded,
                              size: 30.00,
                              color: Colors.blue[300],
                            ),
                            Text(
                              "There is no favorite news!",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.blue[300],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Flexible(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: articlesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (layoutProvider.getLayoutOptions ==
                                LayoutOptions.Standard) {
                              return StandardWidget(
                                articleModel: articlesList[index],
                              );
                            } else if (layoutProvider.getLayoutOptions ==
                                LayoutOptions.TextOnly) {
                              return TextOnlyWidget(
                                articleModel: articlesList[index],
                              );
                            } else {
                              return ImageOnlyWidget(
                                articleModel: articlesList[index],
                              );
                            }
                          },
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
