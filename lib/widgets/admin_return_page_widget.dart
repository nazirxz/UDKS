// lib/widgets/admin_return_page_widget.dart
import 'package:flutter/material.dart';

class AdminReturnPageWidget extends StatefulWidget {
  const AdminReturnPageWidget({super.key});

  @override
  State<AdminReturnPageWidget> createState() => _AdminReturnPageWidgetState();
}

class _AdminReturnPageWidgetState extends State<AdminReturnPageWidget> {
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
      // Simulasi data untuk sementara
      final data = [
        {
          'id': 1,
          'nama_barang': 'Minyak Goreng Tropical 2L',
          'kategori': 'Minyak Goreng',
          'tanggal_return': '2024-12-25',
          'jumlah': 5,
          'customer': 'Toko Berkah',
          'alasan_return': 'Kemasan Rusak',
          'status': 'Approved',
          'nilai_return': 125000
        },
        {
          'id': 2,
          'nama_barang': 'Beras Premium 5kg',
          'kategori': 'Beras',
          'tanggal_return': '2024-12-24',
          'jumlah': 3,
          'customer': 'Warung Ibu Sari',
          'alasan_return': 'Kualitas Tidak Sesuai',
          'status': 'Pending',
          'nilai_return': 180000
        }
      ];
      const chart = [
        {'day_short': 'Sen', 'total_items': 8},
        {'day_short': 'Sel', 'total_items': 12},
        {'day_short': 'Rab', 'total_items': 6},
        {'day_short': 'Kam', 'total_items': 15},
        {'day_short': 'Jum', 'total_items': 18},
        {'day_short': 'Sab', 'total_items': 10},
        {'day_short': 'Min', 'total_items': 7}
      ];
      const cats = ['Semua Kategori', 'Minyak Goreng', 'Beras', 'Gula', 'Tepung', 'Mie Instan'];
      const reasons = ['Semua Alasan', 'Kemasan Rusak', 'Kualitas Tidak Sesuai', 'Salah Kirim', 'Expired', 'Cacat Produk'];
      const status = ['Semua Status', 'Pending', 'Approved', 'Rejected'];

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

  Future<void> _handleSearch(String query, String category, String reason, String status) async {
    try {
      // Simulasi filter untuk sementara
      List<Map<String, dynamic>> filtered = List.from(returnData);

      if (category != 'Semua Kategori') {
        filtered = filtered.where((item) => item['kategori'] == category).toList();
      }

      if (reason != 'Semua Alasan') {
        filtered = filtered.where((item) => item['alasan_return'] == reason).toList();
      }

      if (status != 'Semua Status') {
        filtered = filtered.where((item) => item['status'] == status).toList();
      }

      if (query.isNotEmpty) {
        filtered = filtered.where((item) => 
          item['nama_barang'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['kategori'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['customer'].toString().toLowerCase().contains(query.toLowerCase()) ||
          item['alasan_return'].toString().toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
      
      setState(() {
        filteredReturnData = filtered;
      });
    } catch (e) {
      // Handle error silently for now
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
      // Simulasi delete untuk sementara
      const success = true;
      
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
            _buildReturnTable(),
            
            const SizedBox(height: 20),
            
            // Return Chart
            _buildReturnChart(),
            
            // Bottom spacing for better UX
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tabel Return Barang Mingguan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama barang, kategori, customer, atau alasan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                _handleSearch(value, 'Semua Kategori', 'Semua Alasan', 'Semua Status');
              },
            ),
            
            const SizedBox(height: 16),
            
            // Return Table
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
                    DataColumn(label: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Tanggal Return', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Alasan Return', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Nilai Return', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredReturnData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(item['nama_barang'] ?? '')),
                        DataCell(Text(item['customer'] ?? '')),
                        DataCell(Text(_formatDate(item['tanggal_return']))),
                        DataCell(Text('${item['jumlah']} pcs')),
                        DataCell(Text(item['alasan_return'] ?? '')),
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
                        DataCell(Text('Rp ${_formatCurrency(item['nilai_return'] ?? 0)}')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => _showDeleteConfirmation(item['id']),
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

  Widget _buildReturnChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Return Mingguan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Total barang return per hari',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: _buildBarChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    if (chartData.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Find max value for scaling
    const maxValue = 20; // Fixed max value for demo
    const scaledMaxValue = 22.0; // 20 + 10%

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: chartData.map((data) {
          final totalItems = (data['total_items'] ?? 0).toDouble();
          final dayShort = data['day_short'] ?? '';
          final barHeight = scaledMaxValue > 0 ? (totalItems / scaledMaxValue) * 180 : 0;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Value label on top of bar
                  if (totalItems > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${totalItems.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 16),
                  
                  // Bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    width: double.infinity,
                    height: barHeight.clamp(0, 180),
                    constraints: const BoxConstraints(maxWidth: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: totalItems > 0
                            ? [
                                Colors.red.shade300,
                                Colors.red.shade600,
                              ]
                            : [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                              ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      boxShadow: totalItems > 0
                          ? [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Day label
                  Text(
                    dayShort,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDelete(id);
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