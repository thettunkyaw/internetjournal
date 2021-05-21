// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';

// Providers
import '../providers/font_size.provider.dart';

// InternetConnectionLost StatelessWidget Class
class InternetConnectionLost extends StatelessWidget {
  // Static Class Properties
  static String routeName = "/internet-connection-lost";
  
  @override
  Widget build(BuildContext context) {
    // Method Properties
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);
    return SafeArea(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/internet_journal_dark_theme_logo.png",
                width: 300,
                height: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "အင်တာနက် ချိတ်ဆက်မှု ပြတ်တောက်သွားပါသည်။",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontSize: fontSizeProvider.getFontSize - 5,
                  inherit: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
