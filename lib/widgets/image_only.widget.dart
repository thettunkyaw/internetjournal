// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bot_toast/bot_toast.dart';

// Models
import '../models/article.model.dart';

// Pages
import '../pages/article.page.dart';

// Providers
import '../providers/font_size.provider.dart';
import '../providers/favorite.provider.dart';

// ImageOnlyWidget StatelessWidget Class
class ImageOnlyWidget extends StatelessWidget {
  // Final Properties
  final ArticleModel articleModel;

  // Constructor
  ImageOnlyWidget({
    @required this.articleModel,
  });

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Properties
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
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
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: this.articleModel.imageLink,
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
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
