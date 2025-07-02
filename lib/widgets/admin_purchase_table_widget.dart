// lib/widgets/admin_purchase_table_widget.dart
import 'package:flutter/material.dart';

class AdminPurchaseTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> purchaseData;
  final List<String> categories;
  final Function(int) onDelete;
  final Function(String, String) onSearch;

  const AdminPurchaseTableWidget({
    super.key,
    required this.purchaseData,
    required this.categories,
    required this.onDelete,
    required this.onSearch,
  });

  @override
  State<AdminPurchaseTableWidget> createState() => _AdminPurchaseTableWidgetState();
}

class _AdminPurchaseTableWidgetState extends State<AdminPurchaseTableWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';
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
                    'Tabel Barang Masuk Mingguan',
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
            hintText: 'Cari nama barang, kategori, supplier, atau lokasi...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      widget.onSearch('', _selectedCategory);
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
            widget.onSearch(value, _selectedCategory);
          },
        ),
        
        const SizedBox(height: 12),
        
        // Category Filter
        Row(
          children: [
            const Text(
              'Kategori: ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 'Semua Kategori';
                  });
                  widget.onSearch(_searchController.text, _selectedCategory);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mode 1: Horizontal Scrollable Table (Original DataTable)
  Widget _buildScrollableTable() {
    if (widget.purchaseData.isEmpty) {
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
              label: Text('Tanggal Masuk', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Supplier', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Harga Satuan', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Total Harga', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Lokasi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: widget.purchaseData.asMap().entries.map((entry) {
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
                    child: Text(_formatDate(item['tanggal_masuk'])),
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
                    width: 150,
                    child: Text(
                      item['supplier'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    'Rp ${_formatCurrency(item['harga_satuan'] ?? 0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(
                  Text(
                    'Rp ${_formatCurrency(item['total_harga'] ?? 0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 140,
                    child: Text(
                      item['lokasi_stok'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
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
    if (widget.purchaseData.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text('Nama Barang', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text('Kategori', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text('Tanggal', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text('Qty', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text('Supplier', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text('Total', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text('Aksi', 
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Table Rows
              ...widget.purchaseData.asMap().entries.map((entry) {
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
                          style: const TextStyle(fontSize: 10),
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
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Tooltip(
                          message: item['kategori'] ?? '',
                          child: Text(
                            item['kategori'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          _formatDateShort(item['tanggal_masuk']),
                          style: const TextStyle(fontSize: 9),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          '${item['jumlah']}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Tooltip(
                          message: item['supplier'] ?? '',
                          child: Text(
                            item['supplier'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 9),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          'Rp ${_formatCurrencyShort(item['total_harga'] ?? 0)}',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 16),
                          onPressed: () => _showDeleteConfirmation(item['id']),
                          tooltip: 'Hapus',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
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

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateShort(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}';
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