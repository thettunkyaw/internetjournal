// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

// Models
import '../models/article.model.dart';

// Pages
import '../pages/article.page.dart';
import '../pages/link.page.dart';

// Providers
import '../providers/font_size.provider.dart';
import '../providers/favorite.provider.dart';

// TextOnlyWidget StatelessWidget Class
class TextOnlyWidget extends StatelessWidget {
  // Final Properties
  final ArticleModel articleModel;

  // Constructor
  TextOnlyWidget({
    @required this.articleModel,
  });

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Properties
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context,);
    bool isContain = favoriteProvider.isContain(articleModel);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ArticlePage.routeName,
          arguments: this.articleModel,
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          bottom: 10.0,
        ),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 20.0,
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
                        this.articleModel.title,
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
                        horizontal: 10.0,
                      ),
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        alignment: Alignment.topCenter,
                        icon: Icon(
                          (isContain == true) ? Icons.star : Icons.star_outline,
                          size: 30.0,
                          color: Color(
                            0xffffD700,
                          ),
                        ),
                        onPressed: () {
                          if (isContain) {
                            favoriteProvider.removeInfo(articleModel);
                            BotToast.showText(
                              text: "Successfully Removed!",
                            );
                          } else {
                            favoriteProvider.addInfo(articleModel);
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
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 15.0,
                  right: 15.0,
                  bottom: 10.0,
                ),
                child: Html(
                  data: this.articleModel.description,
                  onLinkTap: (String internalUrl) {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return LinkPage(
                    //         url: internalUrl,
                    //       );
                    //     },
                    //   ),
                    // );
                    Navigator.pushNamed(
                      context,
                      LinkPage.routeName,
                      arguments: internalUrl,
                    );
                  },
                  style: {
                    "body": Style(
                      alignment: Alignment.center,
                      fontSize: FontSize(
                        fontSizeProvider.getFontSize - 5,
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
