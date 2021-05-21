// Flutter: Existing Libraries
import 'package:flutter/material.dart';

// Flutter: External Libraries
import 'package:provider/provider.dart';

// Providers
import '../providers/theme.provider.dart';

// SplashPage StatelessWidget Class
class SplashPage extends StatelessWidget {
  // Build Method
  @override
  Widget build(BuildContext context) {
    // Normal Methods Properties
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.getDarkBoolValue;
    
    // Returning Widgets
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (isDark)
            ? Image.asset(
                "assets/images/internet_journal_dark_logo.png",
                width: 300,
                height: 150,
              )
            : Image.asset(
                "assets/images/internet_journal_image_with_text.png",
                width: 300,
                height: 150,
              ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
