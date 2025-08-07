import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // 讀取使用者偏好
  final isDark = prefs.getBool('darkMode') ?? false;
  final langCode = prefs.getString('language') ?? 'en';

  runApp(MyApp(
    initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    initialLocale: Locale(langCode),
  ));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  final Locale initialLocale;

  const MyApp({
    Key? key,
    required this.initialThemeMode,
    required this.initialLocale,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
  }

  void _changeThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  void _changeLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory App',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('zh')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginPage(
        onLocaleChanged: _changeLocale,
        onThemeModeChanged: _changeThemeMode,
      ),
    );
  }
}
