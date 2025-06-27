// lib/widgets/manager_purchase_page_widget.dart
import 'package:flutter/material.dart';
import '../services/manager_purchase_data_service.dart';
import 'manager_purchase_table_widget.dart';
import 'manager_purchase_chart_widget.dart';

class ManagerPurchasePageWidget extends StatefulWidget {
  const ManagerPurchasePageWidget({Key? key}) : super(key: key);

  @override
  _ManagerPurchasePageWidgetState createState() => _ManagerPurchasePageWidgetState();
}

class _ManagerPurchasePageWidgetState extends State<ManagerPurchasePageWidget> {
  List<Map<String, dynamic>> purchaseData = [];
  List<Map<String, dynamic>> filteredPurchaseData = [];
  List<Map<String, dynamic>> chartData = [];
  List<String> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPurchaseData();
  }

  Future<void> _loadPurchaseData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ManagerPurchaseDataService.getWeeklyPurchaseData();
      final chart = await ManagerPurchaseDataService.getWeeklyPurchaseChart();
      final cats = await ManagerPurchaseDataService.getCategories();

      setState(() {
        purchaseData = data;
        filteredPurchaseData = data;
        chartData = chart;
        categories = cats;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading purchase data: $e');
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
      final filtered = await ManagerPurchaseDataService.searchPurchaseData(
        query: query,
        category: category,
      );
      
      setState(() {
        filteredPurchaseData = filtered;
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
      final success = await ManagerPurchaseDataService.deletePurchaseItem(id);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (success) {
        setState(() {
          purchaseData.removeWhere((item) => item['id'] == id);
          filteredPurchaseData.removeWhere((item) => item['id'] == id);
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 16),
              Text(
                'Memuat data pembelian...',
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
      onRefresh: _loadPurchaseData,
      color: Colors.blue,
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
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
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
                        Icons.shopping_bag,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Data Pembelian',
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
                    'Kelola dan pantau data pembelian mingguan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Purchase Table
            ManagerPurchaseTableWidget(
              purchaseData: filteredPurchaseData,
              categories: categories,
              onDelete: _handleDelete,
              onSearch: _handleSearch,
            ),
            
            const SizedBox(height: 20),
            
            // Purchase Chart
            ManagerPurchaseChartWidget(chartData: chartData),
            
            // Bottom spacing for better UX
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}