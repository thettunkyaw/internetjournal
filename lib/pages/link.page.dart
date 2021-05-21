// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';

// Constants
import '../constants/pop_up_menu.constant.dart';

// Providers
import '../providers/theme.provider.dart';

// LinkPage StatefulWidget Class
class LinkPage extends StatefulWidget {
  // Static Class Properties
  static String routeName = "/link-page";

  // // Final Properties
  // final String url;

  // // Constructor
  // LinkPage({
  //   @required this.url,
  // });

  @override
  _LinkPageState createState() => _LinkPageState();
}

// _LinkPageState State Class
class _LinkPageState extends State<LinkPage> {
  // Class Properties (Final)
  WebViewController _controller;

  // Class Properties (Action)
  bool _isLoading = true;

  // Action Method
  void _choiceAction(String choice, String url) {
    if (choice == PopUpMenuConstant.OpenInDefaultBrowser) {
      _launchUrl(url);
    } else if (choice == PopUpMenuConstant.CopyLink) {
      _copyLink(url);
    } else {
      _reloadPage(url);
    }
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch ${url}!";
    }
  }

  void _copyLink(String url) {
    FlutterClipboard.copy(url).then((value) {
      // Toast.show("Copied Link!", context);
      // BotToast.showSimpleNotification(title: "Copied Url!");
      BotToast.showText(text: "Link copied");
    });
  }

  void _reloadPage(String url) {
    // this._controller.reload();
    this._controller.loadUrl(url);
  }

  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Method Properties
    String url = ModalRoute.of(context).settings.arguments;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.getDarkBoolValue;

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
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(0, 35,),
            onSelected: (String choice) {
              this._choiceAction(choice, url);
            },
            itemBuilder: (BuildContext context) {
              return [
                ...PopUpMenuConstant.Choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }),
                PopupMenuDivider(
                  height: 10.0,
                ),
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    "Internet Journal Mobile Browser",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                this._controller = controller;
              },
              onPageStarted: (String pageStarted) {
                setState(() {
                  this._isLoading = true;
                });
              },
              onPageFinished: (String pageFinished) {
                setState(() {
                  this._isLoading = false;
                });
              },
            ),
            if (this._isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
