import 'package:flutter/material.dart';
import '../localization.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'notification_detail_page.dart';

// class NotificationPage extends StatelessWidget {
  // final Map<String, List<String>> notifications = {
  //   'company': [
  //     '公司年度大會 8/15 舉行',
  //     '新的福利政策將於 9 月生效',
  //   ],
  //   'department': [
  //     '部門聚餐 8/10 晚上 6 點',
  //     '請於本週完成月報',
  //   ],
  //   'supplier': [
  //     '供應商 A 延遲交貨',
  //     '供應商 B 提供折扣方案',
  //   ],
  // };
  

//   @override
//   Widget build(BuildContext context) {
//     final t = AppLocalizations.of(context)!;

//     return DefaultTabController(
//       length: 3,
//       child: Column(
//         children: [
//           Container(
//             color: Theme.of(context).primaryColor,
//             child: TabBar(
//               labelColor: Colors.white,
//               unselectedLabelColor: Colors.white70,
//               tabs: [
//                 Tab(text: t.translate('company_notice')),
//                 Tab(text: t.translate('department_notice')),
//                 Tab(text: t.translate('supplier_notice')),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _buildList(notifications['company']!, t),
//                 _buildList(notifications['department']!, t),
//                 _buildList(notifications['supplier']!, t),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildList(List<String> items, AppLocalizations t) {
//     if (items.isEmpty) {
//       return Center(child: Text(t.translate('no_notifications')));
//     }
//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: items.length,
//       separatorBuilder: (_, __) => Divider(),
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Icon(Icons.notification_important, color: Colors.orange),
//           title: Text(items[index]),
//         );
//       },
//     );
//   }
// }
class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, List<String>> _allNotifications = {
    'company': [],
    'department': [],
    'supplier': [],
  };

  Map<String, List<String>> _filteredNotifications = {
    'company': [],
    'department': [],
    'supplier': [],
  };

  String _searchText = '';

  Future<void> loadNotifications() async {
    final String jsonString = await rootBundle.loadString('assets/data/notifications.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    setState(() {
      _allNotifications = {
        'company': List<String>.from(jsonMap['company']),
        'department': List<String>.from(jsonMap['department']),
        'supplier': List<String>.from(jsonMap['supplier']),
      };
      _applyFilter();
    });
  }

  void _applyFilter() {
    setState(() {
      _filteredNotifications = {
        for (var key in _allNotifications.keys)
          key: _allNotifications[key]!
              .where((msg) => msg.toLowerCase().contains(_searchText.toLowerCase()))
              .toList()
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('notification')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: t.translate('company')),
            Tab(text: t.translate('department')),
            Tab(text: t.translate('supplier')),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.translate('search'),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                _searchText = value;
                _applyFilter();
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_filteredNotifications['company']!),
                _buildList(_filteredNotifications['department']!),
                _buildList(_filteredNotifications['supplier']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<String> messages) {
    if (messages.isEmpty && _searchText.isNotEmpty) {
      return Center(child: Text('🔍 No results found.'));
    }
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) {
        return ListTile(
          leading: Icon(Icons.notifications),
          title: Text(messages[index]),
          onTap: () => _openDetailPage(messages[index]),
        );
      },
    );
  }

  void _openDetailPage(String message) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailPage(message: message),
      ),
    );
  }
}