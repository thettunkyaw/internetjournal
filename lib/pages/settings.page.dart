// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

// Providers
import '../providers/theme.provider.dart';
import '../providers/layout.provider.dart';
import '../providers/font_size.provider.dart';

// Constants
import '../constants/theme.constant.dart';

// Pages
import '../pages/link.page.dart';

// SettingsPage StatelessWidget Class
class SettingsPage extends StatelessWidget {
  // Static Class Properties
  static String routeName = "/settings";
  // Widget Methods
  Widget _titleWidget(String title, FontSizeProvider fontSizeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10,
      ),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: fontSizeProvider.getFontSize - 10,
        ),
      ),
    );
  }

  Widget _qrCodeWidget(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: QrImage(
          data: "https://internetjournal.media/downloads",
          size: 250,
          foregroundColor:
              (themeProvider.getDarkBoolValue) ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Method Properties
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);
    bool isDark = themeProvider.getDarkBoolValue;
    Color iconColor = themeProvider.getThemeData.textTheme.headline1.color;
    Color displayColor = Theme.of(context).textTheme.overline.color;

    // Method Properties (Final)
    const SizedBox _sizedBox = const SizedBox(
      height: 30,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "SETTINGS",
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _sizedBox,
                    this._titleWidget(
                      "MODE",
                      fontSizeProvider,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setString(
                          "Theme",
                          "Light",
                        );
                        themeProvider.setThemeData = lightTheme;
                        themeProvider.setDarkBoolValue = false;
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Light",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              (isDark == false) ? Icons.check : null,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setString("Theme", "Dark");
                        themeProvider.setThemeData = darkTheme;
                        themeProvider.setDarkBoolValue = true;
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.nights_stay_outlined,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Dark",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              (isDark == true) ? Icons.check : null,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "LAYOUT OPTIONS",
                      fontSizeProvider,
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                          "Layout",
                          "Standard",
                        );
                        layoutProvider.setLayoutOptions =
                            LayoutOptions.Standard;
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.view_quilt_outlined,
                              color: iconColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Standard",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              (layoutProvider.getLayoutOptions ==
                                      LayoutOptions.Standard)
                                  ? Icons.check
                                  : null,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                          "Layout",
                          "TextOnly",
                        );
                        layoutProvider.setLayoutOptions =
                            LayoutOptions.TextOnly;
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.subject_outlined,
                              color: iconColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Text Only",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              (layoutProvider.getLayoutOptions ==
                                      LayoutOptions.TextOnly)
                                  ? Icons.check
                                  : null,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                          "Layout",
                          "ImageOnly",
                        );
                        layoutProvider.setLayoutOptions =
                            LayoutOptions.ImageOnly;
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        child: Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: iconColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Image Only",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              (layoutProvider.getLayoutOptions ==
                                      LayoutOptions.ImageOnly)
                                  ? Icons.check
                                  : null,
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "FONT SIZE",
                      fontSizeProvider,
                    ),
                    Container(
                      height: fontSizeProvider.getFontSize + 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      color: displayColor,
                      child: Slider(
                        value: fontSizeProvider.getFontSize,
                        label: fontSizeProvider.getFontSize.round().toString(),
                        divisions: 15,
                        min: 15,
                        max: 30,
                        onChanged: (double changedFontSize) async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          sharedPreferences.setInt(
                            "FontSize",
                            changedFontSize.toInt(),
                          );
                          fontSizeProvider.setFontSize = changedFontSize;
                        },
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "General",
                      fontSizeProvider,
                    ),
                    GestureDetector(
                      onTap: () {
                        // launch(
                        //   "https://internetjournal.media/about-us/",
                        // );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return LinkPage(
                        //         url: "https://internetjournal.media/about-us/",
                        //       );
                        //     },
                        //   ),
                        // );
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments: "https://internetjournal.media/about-us/",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "About Us",
                          style: TextStyle(
                            color: iconColor,
                            fontSize: fontSizeProvider.getFontSize - 5,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // launch(
                        //   "https://internetjournal.media/contact-us/",
                        // );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return LinkPage(
                        //         url:
                        //             "https://internetjournal.media/contact-us/",
                        //       );
                        //     },
                        //   ),
                        // );
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments:
                              "https://internetjournal.media/contact-us/",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Contact Us",
                          style: TextStyle(
                            color: iconColor,
                            fontSize: fontSizeProvider.getFontSize - 5,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // launch(
                        //   "https://internetjournal.media/terms-and-conditions/",
                        // );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return LinkPage(
                        //         url:
                        //             "https://internetjournal.media/terms-and-conditions/",
                        //       );
                        //     },
                        //   ),
                        // );
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments:
                              "https://internetjournal.media/terms-and-conditions/",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Terms and Conditions",
                          style: TextStyle(
                            color: iconColor,
                            fontSize: fontSizeProvider.getFontSize - 5,
                          ),
                        ),
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "Social Media",
                      fontSizeProvider,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments: "https://bit.ly/2Q9dVnZ",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.facebookSquare,
                              color: iconColor,
                              semanticLabel: "Facebook",
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 10.00,
                            ),
                            Text(
                              "Facebook",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments: "https://bit.ly/3iYm6Qp",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.instagramSquare,
                              semanticLabel: "Instagram",
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 10.00,
                            ),
                            Text(
                              "Instagram",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments: "https://bit.ly/3l4XdnR",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.twitterSquare,
                              semanticLabel: "Twitter",
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 10.00,
                            ),
                            Text(
                              "Twitter",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          LinkPage.routeName,
                          arguments: "https://bit.ly/34u0OpZ",
                        );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.youtubeSquare,
                              semanticLabel: "YouTube",
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 10.00,
                            ),
                            Text(
                              "YouTube",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "Newsletter",
                      fontSizeProvider,
                    ),
                    GestureDetector(
                      onTap: () async {
                        String url =
                            "https://internetjournal.media/newsletter/";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw "Could not launch $url!";
                        }
                        // Navigator.pushNamed(
                        //   context,
                        //   LinkPage.routeName,
                        //   arguments:
                        //       "https://internetjournal.media/newsletter/",
                        // );
                      },
                      child: Container(
                        height: fontSizeProvider.getFontSize + 30,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        color: displayColor,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            // FaIcon(
                            //   FontAwesomeIcons.mail,
                            //   semanticLabel: "YouTube",
                            //   color: iconColor/
                            //   size: fontSizeProvider.getFontSize + 5,
                            // ),
                            Icon(
                              Icons.mail,
                              semanticLabel: "Newsletter",
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                            const SizedBox(
                              width: 10.00,
                            ),
                            Text(
                              "Go to Newsletter",
                              style: TextStyle(
                                color: iconColor,
                                fontSize: fontSizeProvider.getFontSize - 5,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              semanticLabel: "Newsletter",
                              color: iconColor,
                              size: fontSizeProvider.getFontSize + 5,
                            ),
                          ],
                        ),
                        // child: ListTile(
                        //   title: Text(
                        //     "Go to Newsletter",
                        //     style: TextStyle(
                        //       color: iconColor,
                        //       fontSize: fontSizeProvider.getFontSize - 5,
                        //     ),
                        //   ),
                        //   leading: Icon(
                        //     Icons.mail,
                        //     size: fontSizeProvider.getFontSize + 5,
                        //     color: iconColor,
                        //   ),
                        //   trailing: Icon(
                        //     Icons.arrow_forward_ios_outlined,
                        //     color: iconColor,
                        //     size: fontSizeProvider.getFontSize + 5,
                        //   ),
                        // ),
                      ),
                    ),
                    _sizedBox,
                    this._titleWidget(
                      "DOWNLOAD LINK",
                      fontSizeProvider,
                    ),
                    _qrCodeWidget(
                      themeProvider,
                    ),
                    Container(
                      height: fontSizeProvider.getFontSize + 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "© Internet Journal",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: fontSizeProvider.getFontSize - 5,
                          fontStyle: FontStyle.italic,
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
    );
  }
}
