import 'package:flutter/material.dart';
import '../localization.dart';

class InventoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const InventoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final stock = item['stock'] as int;
    final stockLow = stock < 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('product_detail')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: item['image'] != null
                  ? Image.asset(
                    item['image'] ?? 'assets/images/default.png' , 
                    width: 50, 
                    height: 50, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  : Icon(Icons.image_not_supported, size: 100),
            ),
            SizedBox(height: 20),
            Text(
              item['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 8),
            Text('${t.translate('product_id')}: ${item['id']}'),
            Text('${t.translate('category')}: ${item['category']}'),
            Text('${t.translate('stock')}: $stock'),
            if (stockLow)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  t.translate('low_stock'),
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
