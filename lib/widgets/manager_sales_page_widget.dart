// lib/widgets/manager_sales_page_widget.dart
import 'package:flutter/material.dart';
import '../services/manager_sales_data_service.dart';
import 'manager_sales_table_widget.dart';
import 'manager_sales_chart_widget.dart';

class ManagerSalesPageWidget extends StatefulWidget {
  const ManagerSalesPageWidget({Key? key}) : super(key: key);

  @override
  _ManagerSalesPageWidgetState createState() => _ManagerSalesPageWidgetState();
}

class _ManagerSalesPageWidgetState extends State<ManagerSalesPageWidget> {
  List<Map<String, dynamic>> salesData = [];
  List<Map<String, dynamic>> filteredSalesData = [];
  List<Map<String, dynamic>> chartData = [];
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalesData();
  }

  Future<void> _loadSalesData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ManagerSalesDataService.getWeeklySalesData();
      final chart = await ManagerSalesDataService.getWeeklySalesChart();
      final cats = await ManagerSalesDataService.getCategories();

      setState(() {
        salesData = data;
        filteredSalesData = data;
        chartData = chart;
        categories = cats;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading sales data: $e');
      setState(() {
        isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSearch(String query, String category) async {
    try {
      final filtered = await ManagerSalesDataService.searchSalesData(
        query: query,
        category: category,
      );
      
      setState(() {
        filteredSalesData = filtered;
      });
    } catch (e) {
      print('Error searching data: $e');
    }
  }

  Future<void> _handleDelete(int id) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final success = await ManagerSalesDataService.deleteSalesItem(id);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (success) {
        setState(() {
          salesData.removeWhere((item) => item['id'] == id);
          filteredSalesData.removeWhere((item) => item['id'] == id);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dihapus'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus data'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      print('Error deleting item: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
              SizedBox(height: 16),
              Text(
                'Memuat data penjualan...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSalesData,
      color: Colors.purple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Data Penjualan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kelola dan pantau data penjualan mingguan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Sales Table
            ManagerSalesTableWidget(
              salesData: filteredSalesData,
              categories: categories,
              onDelete: _handleDelete,
              onSearch: _handleSearch,
            ),
            
            const SizedBox(height: 20),
            
            // Sales Chart
            ManagerSalesChartWidget(chartData: chartData),
            
            // Bottom spacing for better UX
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}