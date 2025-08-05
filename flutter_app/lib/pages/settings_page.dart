import 'package:flutter/material.dart';
import '../localization.dart';
import '../pages/login_page.dart';

class SettingsPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;

  const SettingsPage({
    super.key, 
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLang = 'en';
  bool _isDarkMode = false;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('settings'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 主題切換
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.translate('dark_mode'), style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() => _isDarkMode = value);
                    widget.onThemeModeChanged(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // 語言切換
            Text(t.translate('language'), style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLang,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'zh', child: Text('中文')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLang = value);
                  widget.onLocaleChanged(Locale(value));
                }
              },
            ),
            SizedBox(height: 24),

            // 修改密碼區塊
            Text(t.translate('change_password'), style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: t.translate('current_password')),
            ),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: t.translate('new_password')),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 此處未實際驗證密碼，僅示意
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.translate('password_updated'))),
                );
                _oldPasswordController.clear();
                _newPasswordController.clear();
              },
              child: Text(t.translate('save')),
            ),
            SizedBox(height: 24),

            // 登出
            ElevatedButton.icon(
              icon: Icon(Icons.logout),
              label: Text(t.translate('logout')),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage(
                    onLocaleChanged: widget.onLocaleChanged,
                    onThemeModeChanged: widget.onThemeModeChanged,
                    )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
