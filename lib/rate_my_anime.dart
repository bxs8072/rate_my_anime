import 'package:flutter/material.dart';
import 'package:rate_my_anime/screens/landing_screen/landing_screen.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/light_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class RateMyAnime extends StatelessWidget {
  const RateMyAnime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: DarkTheme.id,
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light(id: LightTheme.id),
        AppTheme.dark(id: DarkTheme.id),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.themeOf(themeContext).data,
            home: LandingScreen(key: key),
          ),
        ),
      ),
    );
  }
}
