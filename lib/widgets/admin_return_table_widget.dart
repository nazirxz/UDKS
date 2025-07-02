// lib/widgets/admin_return_table_widget.dart
import 'package:flutter/material.dart';

class AdminReturnTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> returnData;
  final List<String> categories;
  final List<String> returnReasons;
  final List<String> returnStatus;
  final Function(int) onDelete;
  final Function(String, String, String, String) onSearch;

  const AdminReturnTableWidget({
    Key? key,
    required this.returnData,
    required this.categories,
    required this.returnReasons,
    required this.returnStatus,
    required this.onDelete,
    required this.onSearch,
  }) : super(key: key);

  @override
  _AdminReturnTableWidgetState createState() => _AdminReturnTableWidgetState();
}

class _AdminReturnTableWidgetState extends State<AdminReturnTableWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';
  String _selectedReason = 'Semua Alasan';
  String _selectedStatus = 'Semua Status';
  bool _useHorizontalScroll = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with View Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Tabel Return Barang Mingguan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: _useHorizontalScroll ? 'Mode Fit Screen' : 'Mode Scroll Horizontal',
                      child: IconButton(
                        icon: Icon(
                          _useHorizontalScroll ? Icons.fit_screen : Icons.swap_horiz,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _useHorizontalScroll = !_useHorizontalScroll;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Search and Filter Section
            _buildSearchAndFilter(),
            const SizedBox(height: 16),
            
            // Data Table
            _useHorizontalScroll ? _buildScrollableTable() : _buildFitScreenTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Column(
      children: [
        // Search Bar
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari nama barang, kategori, customer, atau alasan...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearch('', _selectedCategory, _selectedReason, _selectedStatus);
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          onChanged: (value) {
            widget.onSearch(value, _selectedCategory, _selectedReason, _selectedStatus);
          },
        ),
        
        const SizedBox(height: 12),
        
        // Filters Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Category Filter
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      items: widget.categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value ?? 'Semua Kategori';
                        });
                        widget.onSearch(_searchController.text, _selectedCategory, _selectedReason, _selectedStatus);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Reason Filter
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alasan:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: _selectedReason,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      items: widget.returnReasons.map((reason) {
                        return DropdownMenuItem(
                          value: reason,
                          child: Text(reason, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedReason = value ?? 'Semua Alasan';
                        });
                        widget.onSearch(_searchController.text, _selectedCategory, _selectedReason, _selectedStatus);
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Status Filter
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      items: widget.returnStatus.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value ?? 'Semua Status';
                        });
                        widget.onSearch(_searchController.text, _selectedCategory, _selectedReason, _selectedStatus);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Mode 1: Horizontal Scrollable Table (Original DataTable)
  Widget _buildScrollableTable() {
    if (widget.returnData.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          columnSpacing: 16,
          horizontalMargin: 16,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(
              label: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Tanggal Return', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Alasan Return', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Nilai Return', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: widget.returnData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return DataRow(
              cells: [
                DataCell(Text('${index + 1}')),
                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      item['nama_barang'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      item['kategori'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(_formatDate(item['tanggal_return'])),
                  ),
                ),
                DataCell(
                  Text(
                    '${item['jumlah']} pcs',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 140,
                    child: Text(
                      item['customer'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      item['alasan_return'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
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
                  Text(
                    'Rp ${_formatCurrency(item['nilai_return'] ?? 0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ),
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
    );
  }

  // Mode 2: Fit Screen Table (No Horizontal Scroll)
  Widget _buildFitScreenTable() {
    if (widget.returnData.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Text('No', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Text('Nama Barang', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text('Customer', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text('Alasan', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text('Qty', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text('Status', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text('Nilai', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text('Aksi', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          
          // Table Rows
          ...widget.returnData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isEven = index % 2 == 0;
            
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: isEven ? Colors.white : Colors.grey.shade50,
              ),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Tooltip(
                      message: item['nama_barang'] ?? '',
                      child: Text(
                        item['nama_barang'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 9),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Tooltip(
                      message: item['customer'] ?? '',
                      child: Text(
                        item['customer'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 9),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Tooltip(
                      message: item['alasan_return'] ?? '',
                      child: Text(
                        item['alasan_return'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 8),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      '${item['jumlah']}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['status'] ?? '',
                        style: TextStyle(
                          color: _getStatusColor(item['status']),
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      'Rp ${_formatCurrencyShort(item['nilai_return'] ?? 0)}',
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 14),
                      onPressed: () => _showDeleteConfirmation(item['id']),
                      tooltip: 'Hapus',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada data yang ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
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

  String _formatCurrencyShort(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
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
                widget.onDelete(id);
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