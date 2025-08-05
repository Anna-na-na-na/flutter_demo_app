import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../localization.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Map<String, dynamic>> salesData = [];
  String selectedPeriod = 'month';
  String _searchQuery = '';
  String _selectedCategory = 'All';

  Future<void> loadSalesData() async {
    final String jsonString = await rootBundle.loadString('assets/data/inventory.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      salesData = List<Map<String, dynamic>>.from(jsonData);
    });
  }

  @override
  void initState() {
    super.initState();
    loadSalesData();
  }

  List<Map<String, dynamic>> get filteredData {
    return salesData.where((item) {
      final matchesName = item['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || item['category'] == _selectedCategory;
      return matchesName && matchesCategory;
    }).toList();
  }

  List<String> get categories {
    final unique = salesData.map((e) => e['category'].toString()).toSet().toList();
    unique.sort();
    return ['All', ...unique];
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.translate('sales'))),
      body: Column(
        children: [
          SizedBox(height: 10),
          ToggleButtons(
            isSelected: ['day', 'week', 'month', 'year'].map((p) => p == selectedPeriod).toList(),
            onPressed: (index) {
              setState(() {
                selectedPeriod = ['day', 'week', 'month', 'year'][index];
              });
            },
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text(t.translate('day'))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text(t.translate('week'))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text(t.translate('month'))),
              Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text(t.translate('year'))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.translate('search_product'),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: filteredData.isEmpty
                ? Center(child: Text(t.translate('no_data')))
                : ListView(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: filteredData
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final i = entry.key;
                                    final item = entry.value;
                                    final value = item['sales'][selectedPeriod] ?? 0;
                                    return BarChartGroupData(
                                      x: i,
                                      barRods: [
                                        BarChartRodData(
                                          toY: value.toDouble(),
                                          color: Colors.blueAccent,
                                          width: 18,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ],
                                      showingTooltipIndicators: [0],
                                    );
                                  })
                                  .toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index >= filteredData.length) return SizedBox.shrink();
                                      return Text(
                                        filteredData[index]['name'],
                                        style: TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ...filteredData.map((item) {
                        final value = item['sales'][selectedPeriod] ?? 0;
                        return ListTile(
                          title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${t.translate('category')}: ${item['category']}'),
                          trailing: Text('$value', style: TextStyle(fontSize: 18, color: Colors.blue)),
                        );
                      }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
