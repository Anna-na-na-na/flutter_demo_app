import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization.dart';

class SettingsPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;

  const SettingsPage({
    Key? key,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLang = 'en';
  bool _isDarkMode = false;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('language') ?? 'en';
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _updateLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);
    setState(() => _selectedLang = langCode);
    widget.onLocaleChanged(Locale(langCode));
  }

  Future<void> _updateTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    setState(() => _isDarkMode = isDark);
    widget.onThemeModeChanged(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void _changePassword() {
    final oldPwd = _oldPasswordController.text;
    final newPwd = _newPasswordController.text;
    final t = AppLocalizations.of(context)!;

    if (oldPwd == '123456' && newPwd.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.translate('password_changed')),
      ));
      // 實際應用：應該儲存在安全儲存空間
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.translate('password_change_failed')),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('settings'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(t.translate('language'), style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLang,
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'zh', child: Text('中文')),
              ],
              onChanged: (value) {
                if (value != null) _updateLanguage(value);
              },
            ),
            SizedBox(height: 20),
            Text(t.translate('theme_mode'), style: TextStyle(fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: Text(_isDarkMode ? t.translate('dark') : t.translate('light')),
              value: _isDarkMode,
              onChanged: (value) => _updateTheme(value),
            ),
            SizedBox(height: 20),
            Text(t.translate('change_password'), style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: t.translate('current_password')),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: t.translate('new_password')),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text(t.translate('update_password')),
            ),
          ],
        ),
      ),
    );
  }
}
