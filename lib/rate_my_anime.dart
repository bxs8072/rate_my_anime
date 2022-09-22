import 'package:flutter/material.dart';
import 'package:rate_my_anime/screens/landing_screen/landing_screen.dart';
import 'package:rate_my_anime/services/theme_services/dark_theme.dart';
import 'package:rate_my_anime/services/theme_services/light_theme.dart';
import 'package:rate_my_anime/services/theme_services/theme_service.dart';
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
        AppTheme(
          id: LightTheme.id,
          data: LightTheme.theme,
          description: "Light Theme",
        ),
        AppTheme(
          id: DarkTheme.id,
          data: DarkTheme.darkTheme,
          description: "Dark Theme",
        ),
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
