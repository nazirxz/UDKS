// lib/widgets/manager_return_page_widget.dart
import 'package:flutter/material.dart';
import '../services/manager_return_data_service.dart';
import 'manager_return_table_widget.dart';
import 'manager_return_chart_widget.dart';

class ManagerReturnPageWidget extends StatefulWidget {
  const ManagerReturnPageWidget({Key? key}) : super(key: key);

  @override
  _ManagerReturnPageWidgetState createState() => _ManagerReturnPageWidgetState();
}

class _ManagerReturnPageWidgetState extends State<ManagerReturnPageWidget> {
  List<Map<String, dynamic>> returnData = [];
  List<Map<String, dynamic>> filteredReturnData = [];
  List<Map<String, dynamic>> chartData = [];
  List<String> categories = [];
  List<String> returnReasons = [];
  List<String> returnStatus = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReturnData();
  }

  Future<void> _loadReturnData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ManagerReturnDataService.getWeeklyReturnData();
      final chart = await ManagerReturnDataService.getWeeklyReturnChart();
      final cats = await ManagerReturnDataService.getCategories();
      final reasons = await ManagerReturnDataService.getReturnReasons();
      final status = await ManagerReturnDataService.getReturnStatus();

      setState(() {
        returnData = data;
        filteredReturnData = data;
        chartData = chart;
        categories = cats;
        returnReasons = reasons;
        returnStatus = status;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading return data: $e');
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

  Future<void> _handleSearch(String query, String category, String reason, String status) async {
    try {
      final filtered = await ManagerReturnDataService.searchReturnData(
        query: query,
        category: category,
        reason: reason,
        status: status,
      );
      
      setState(() {
        filteredReturnData = filtered;
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
      final success = await ManagerReturnDataService.deleteReturnItem(id);
      
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      if (success) {
        setState(() {
          returnData.removeWhere((item) => item['id'] == id);
          filteredReturnData.removeWhere((item) => item['id'] == id);
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              SizedBox(height: 16),
              Text(
                'Memuat data return...',
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
      onRefresh: _loadReturnData,
      color: Colors.orange,
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
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
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
                        Icons.assignment_return,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Data Return',
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
                    'Kelola dan pantau data return barang mingguan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Return Table
            ManagerReturnTableWidget(
              returnData: filteredReturnData,
              categories: categories,
              returnReasons: returnReasons,
              returnStatus: returnStatus,
              onDelete: _handleDelete,
              onSearch: _handleSearch,
            ),
            
            const SizedBox(height: 20),
            
            // Return Chart
            ManagerReturnChartWidget(chartData: chartData),
            
            // Bottom spacing for better UX
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}