import 'package:flutter/material.dart';
import '../localization.dart';

class NotificationDetailPage extends StatelessWidget {
  final String message;

  const NotificationDetailPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('notification_detail')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
