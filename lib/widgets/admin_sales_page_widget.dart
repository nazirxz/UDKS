// lib/widgets/admin_sales_page_widget.dart
import 'package:flutter/material.dart';

class AdminSalesPageWidget extends StatefulWidget {
  const AdminSalesPageWidget({super.key});

  @override
  State<AdminSalesPageWidget> createState() => _AdminSalesPageWidgetState();
}

class _AdminSalesPageWidgetState extends State<AdminSalesPageWidget> {
  List<Map<String, dynamic>> orderData = [];
  List<Map<String, dynamic>> filteredOrderData = [];
  List<Map<String, dynamic>> vehicleData = [];
  List<Map<String, dynamic>> filteredVehicleData = [];
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
      // Simulasi data untuk demo
      const orders = [
        {
          'id': 1,
          'order_number': 'ORD001',
          'customer': 'PT. Maju Jaya',
          'product': 'Minyak Goreng Tropical 2L',
          'quantity': 50,
          'total_price': 1250000,
          'order_date': '2024-12-25',
          'status': 'Diproses'
        },
        {
          'id': 2,
          'order_number': 'ORD002',
          'customer': 'Toko Berkah',
          'product': 'Beras Premium 5kg',
          'quantity': 30,
          'total_price': 1800000,
          'order_date': '2024-12-25',
          'status': 'Pending'
        }
      ];
      const vehicles = [
        {
          'id': 1,
          'type': 'Truk',
          'plate_number': 'B 1234 ABC',
          'sales': 'Ahmad Rizki',
          'route': 'Jakarta - Tangerang',
          'description': 'Truk box 4 ton untuk distribusi area barat'
        },
        {
          'id': 2,
          'type': 'Pick Up',
          'plate_number': 'B 5678 DEF',
          'sales': 'Siti Nurhaliza',
          'route': 'Jakarta - Bekasi',
          'description': 'Pick up untuk distribusi area timur'
        }
      ];
      const cats = ['Semua Kategori', 'Minyak Goreng', 'Beras', 'Gula', 'Tepung', 'Mie Instan'];

      setState(() {
        orderData = orders;
        filteredOrderData = orders;
        vehicleData = vehicles;
        filteredVehicleData = vehicles;
        categories = cats;
        isLoading = false;
      });
    } catch (e) {
      // Handle error silently for demo
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

  Future<void> _handleOrderSearch(String query, String status) async {
    try {
      // Simulasi filter untuk demo
      List<Map<String, dynamic>> filtered = List.from(orderData);

      if (status != 'Semua Status') {
        filtered = filtered.where((item) => item['status'] == status).toList();
      }

      if (query.isNotEmpty) {
        filtered = filtered.where((item) => 
          item['customer'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['order_number'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['product'].toString().toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
      
      setState(() {
        filteredOrderData = filtered;
      });
    } catch (e) {
      // Handle error silently for demo
    }
  }

  Future<void> _handleVehicleSearch(String query, String type) async {
    try {
      // Simulasi filter untuk demo
      List<Map<String, dynamic>> filtered = List.from(vehicleData);

      if (type != 'Semua Type') {
        filtered = filtered.where((item) => item['type'] == type).toList();
      }

      if (query.isNotEmpty) {
        filtered = filtered.where((item) => 
          item['plate_number'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['sales'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['route'].toString().toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
      
      setState(() {
        filteredVehicleData = filtered;
      });
    } catch (e) {
      // Handle error silently for demo
    }
  }

  Future<void> _handleOrderDelete(int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Simulasi delete untuk demo
      const success = true;
      
      if (mounted) Navigator.of(context).pop();
      
      if (success) {
        setState(() {
          orderData.removeWhere((item) => item['id'] == id);
          filteredOrderData.removeWhere((item) => item['id'] == id);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pesanan berhasil dihapus'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus pesanan'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      
      // Handle error silently for demo
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

  Future<void> _handleVehicleDelete(int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Simulasi delete untuk demo
      const success = true;
      
      if (mounted) Navigator.of(context).pop();
      
      if (success) {
        setState(() {
          vehicleData.removeWhere((item) => item['id'] == id);
          filteredVehicleData.removeWhere((item) => item['id'] == id);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data kendaraan berhasil dihapus'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus data kendaraan'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      
      // Handle error silently for demo
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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
      color: Colors.red,
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
                  colors: [Colors.red.shade400, Colors.red.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
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
                    'Kelola pesanan barang dan kendaraan distribusi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            
            // Order Table
            _buildOrderTable(),
            
            const SizedBox(height: 20),
            
            // Vehicle Table
            _buildVehicleTable(),
            
            // Bottom spacing for better UX
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tabel Pemesanan Barang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Bar untuk Order
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama customer, nomor pesanan, atau produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) async {
                await _handleOrderSearch(value, 'Semua Status');
              },
            ),
            
            const SizedBox(height: 16),
            
            // Order Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('No. Pesanan', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Produk', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Total Harga', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredOrderData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(item['order_number'] ?? '')),
                        DataCell(Text(item['customer'] ?? '')),
                        DataCell(Text(item['product'] ?? '')),
                        DataCell(Text('${item['quantity']} pcs')),
                        DataCell(Text('Rp ${_formatCurrency(item['total_price'] ?? 0)}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['status'] ?? '',
                              style: TextStyle(
                                color: _getStatusColor(item['status']),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _showDeleteConfirmation(item['id'], true),
                            tooltip: 'Hapus',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Kendaraan Distribusi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Bar untuk Vehicle
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari plat nomor, sales, atau rute...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) async {
                await _handleVehicleSearch(value, 'Semua Type');
              },
            ),
            
            const SizedBox(height: 16),
            
            // Vehicle Table
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                  columns: const [
                    DataColumn(label: Text('No', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Plat Nomor', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Rute', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Keterangan', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredVehicleData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getTypeColor(item['type']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['type'] ?? '',
                              style: TextStyle(
                                color: _getTypeColor(item['type']),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        DataCell(Text(item['plate_number'] ?? '')),
                        DataCell(Text(item['sales'] ?? '')),
                        DataCell(Text(item['route'] ?? '')),
                        DataCell(Text(item['description'] ?? '')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _showDeleteConfirmation(item['id'], false),
                            tooltip: 'Hapus',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.blue;
      case 'dikirim':
        return Colors.orange;
      case 'pending':
        return Colors.amber;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'truk':
        return Colors.blue;
      case 'pick up':
        return Colors.green;
      case 'motor box':
        return Colors.orange;
      case 'van':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showDeleteConfirmation(int id, bool isOrder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus ${isOrder ? 'pesanan' : 'data kendaraan'} ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isOrder) {
                  _handleOrderDelete(id);
                } else {
                  _handleVehicleDelete(id);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}