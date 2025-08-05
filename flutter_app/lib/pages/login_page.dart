import 'package:flutter/material.dart';
import '../localization.dart';
// import 'home_page.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;

  LoginPage({
    required this.onLocaleChanged,
    required this.onThemeModeChanged});
  

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String selectedLang;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLang = Localizations.localeOf(context).languageCode;
      setState(() {
        selectedLang = currentLang;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = emailController.text;
    final password = passwordController.text;
    final t = AppLocalizations.of(context)!;

    if (email == 'test@example.com' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            onLocaleChanged: widget.onLocaleChanged,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ),
      );
      // SnackBar 建議移除或改放在 MainPage 顯示
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.translate('invalid_credentials'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(t.translate('login'), style: TextStyle(fontSize: 28)),
                SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: t.translate('email')),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: t.translate('password')),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(t.translate('language') + ':'),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedLang,
                      items: [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'zh', child: Text('中文')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedLang = value);
                          widget.onLocaleChanged(Locale(value));
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text(t.translate('login')),
                ),
                SizedBox(height: 20),
                Text(t.translate('or_login_with')),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(onPressed: () {}, child: Text('Google')),
                    SizedBox(width: 10),
                    OutlinedButton(onPressed: () {}, child: Text('Apple')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
