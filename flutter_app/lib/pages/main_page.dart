import 'package:flutter/material.dart';
import '../localization.dart';
import 'inventory_page.dart';
import 'notification_page.dart';
import 'sales_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;

  const MainPage({
    required this.onLocaleChanged, 
    required this.onThemeModeChanged,
    Key? key
    }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2; // 預設顯示銷售頁

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      NotificationPage(),
      InventoryPage(),
      SalesPage(),
      SettingsPage(
        onLocaleChanged: widget.onLocaleChanged,
        onThemeModeChanged: widget.onThemeModeChanged,
        ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: t.translate('notification'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: t.translate('inventory'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: t.translate('sales'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: t.translate('settings'),
          ),
        ],
      ),
    );
  }
}
