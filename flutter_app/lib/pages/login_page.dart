import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization.dart';
import 'main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;

  const LoginPage({
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedLang = 'en';
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    final savedPassword = prefs.getString('saved_password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', emailController.text);
      await prefs.setString('saved_password', passwordController.text);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
    }
  }

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final t = AppLocalizations.of(context)!;

    // 測試用帳號
    const String testEmail = 'test@test.com';
    const String testPassword = '12345';

    // 若為預設帳號則直接跳過 Firebase 驗證
    if (email == testEmail && password == testPassword) {
      await _saveCredentials();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            onLocaleChanged: widget.onLocaleChanged,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate('login_success'))));
      return;
    }

    try {
      // Firebase 驗證
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await _saveCredentials();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            onLocaleChanged: widget.onLocaleChanged,
            onThemeModeChanged: widget.onThemeModeChanged,
          ),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate('login_success'))));
    } on FirebaseAuthException catch (e) {
      String errorMsg;
      switch (e.code) {
        case 'user-not-found':
          errorMsg = t.translate('user_not_found');
          break;
        case 'wrong-password':
          errorMsg = t.translate('wrong_password');
          break;
        case 'invalid-email':
          errorMsg = t.translate('invalid_email');
          break;
        default:
          errorMsg = e.message ?? t.translate('login_failed');
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.translate('login_failed'))));
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
                  decoration: InputDecoration(
                    labelText: t.translate('password'),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) => setState(() => rememberMe = value!),
                    ),
                    Text(t.translate('remember_me')),
                  ],
                ),
                Row(
                  children: [
                    Text('${t.translate('language')}:'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
