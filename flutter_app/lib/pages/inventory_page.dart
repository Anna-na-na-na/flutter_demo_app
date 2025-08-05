import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../localization.dart';
import 'inventory_detail_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Map<String, dynamic>> inventoryItems = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _sortAscending = true;

  List<String> get allCategories {
    final categories = inventoryItems.map((e) => e['category'].toString()).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  List<Map<String, dynamic>> get filteredItems {
    List<Map<String, dynamic>> list = inventoryItems.where((item) {
      final name = item['name'].toString().toLowerCase();
      final category = item['category'].toString();
      return name.contains(_searchQuery) &&
          (_selectedCategory == 'All' || category == _selectedCategory);
    }).toList();

    list.sort((a, b) => _sortAscending
        ? a['stock'].compareTo(b['stock'])
        : b['stock'].compareTo(a['stock']));

    return list;
  }

  Future<void> loadInventory() async {
    final String jsonString = await rootBundle.loadString('assets/data/inventory.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      inventoryItems = List<Map<String, dynamic>>.from(jsonData);
    });
  }

  @override
  void initState() {
    super.initState();
    loadInventory();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.translate('inventory')),
        actions: [
          IconButton(
            icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
          )
        ],
      ),
      body: inventoryItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: t.translate('search_product'),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value.toLowerCase());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: allCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, index) {
                      final item = filteredItems[index];
                      final stock = item['stock'];
                      final imagePath = item['image'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: imagePath != null
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
                              : Icon(Icons.inventory),
                          title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${t.translate('product_id')}: ${item['id']}'),
                              Text('${t.translate('category')}: ${item['category']}'),
                              if (stock < 10)
                                Text(
                                  t.translate('low_stock'),
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                          trailing: Text(
                            '$stock',
                            style: TextStyle(
                              fontSize: 18,
                              color: stock > 10 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InventoryDetailPage(item: item),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
