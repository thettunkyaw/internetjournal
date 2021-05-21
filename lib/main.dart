// Flutter: Exsiting Libraries
import 'package:flutter/material.dart';

// Flutter: External Libararies
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

// Providers
import './providers/font_size.provider.dart';
import './providers/layout.provider.dart';
import './providers/theme.provider.dart';
import './providers/favorite.provider.dart';

// Pages
import './pages/home.page.dart';
import './pages/article.page.dart';
import './pages/category.page.dart';
import './pages/settings.page.dart';
import './pages/internet_connection_lost.page.dart';
import './pages/link.page.dart';
import './pages/favorite.page.dart';

// Main Function
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LayoutProvider()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MyApp(),
    ),
  );
}

// MyApp StatelessWidget Class
class MyApp extends StatelessWidget {
  // Build Method
  @override
  Widget build(BuildContext context) {
    // Method Properties
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    LayoutProvider layoutProvider = Provider.of<LayoutProvider>(context);
    FontSizeProvider fontSizeProvider = Provider.of<FontSizeProvider>(context);

    themeProvider.setSharedPreferencesValue();
    layoutProvider.setSharedPreferencesValue();
    fontSizeProvider.setSharedPreferencesValue();

    return MaterialApp(
      title: 'Internet Journal',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      theme: Provider.of<ThemeProvider>(context).getThemeData,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => HomePage(),
        ArticlePage.routeName: (_) => ArticlePage(),
        CategoryPage.routeName: (_) => CategoryPage(),
        SettingsPage.routeName: (_) => SettingsPage(),
        InternetConnectionLost.routeName: (_) => InternetConnectionLost(),
        LinkPage.routeName: (_) => LinkPage(),
        FavoritePage.routeName: (_) => FavoritePage(),
      },
    );
  }
}
