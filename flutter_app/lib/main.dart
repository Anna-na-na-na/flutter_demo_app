import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<Locale> _locale = ValueNotifier(Locale('en'));
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: _locale,
      builder: (_, locale, __) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: _themeMode,
          builder: (_, themeMode, __) {
            return MaterialApp(
              title: 'Inventory App',
              locale: locale,
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              supportedLocales: [Locale('en'), Locale('zh')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: LoginPage(
                onLocaleChanged: (newLocale) => _locale.value = newLocale,
                onThemeModeChanged: (mode) => _themeMode.value = mode,
              ),
            );
          },
        );
      },
    );
  }
}