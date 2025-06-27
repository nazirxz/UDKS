// lib/widgets/manager_sales_table_widget.dart
import 'package:flutter/material.dart';

class ManagerSalesTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> salesData;
  final List<String> categories;
  final Function(int) onDelete;
  final Function(String, String) onSearch;

  const ManagerSalesTableWidget({
    Key? key,
    required this.salesData,
    required this.categories,
    required this.onDelete,
    required this.onSearch,
  }) : super(key: key);

  @override
  _ManagerSalesTableWidgetState createState() => _ManagerSalesTableWidgetState();
}

class _ManagerSalesTableWidgetState extends State<ManagerSalesTableWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua Kategori';

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
            // Header
            const Text(
              'Tabel Barang Terjual Mingguan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Search and Filter Section
            _buildSearchAndFilter(),
            const SizedBox(height: 16),
            
            // Data Table
            _buildDataTable(),
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
            hintText: 'Cari nama barang, kategori, atau lokasi...',
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
              borderSide: const BorderSide(color: Colors.blue),
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

  Widget _buildDataTable() {
    if (widget.salesData.isEmpty) {
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
              label: SizedBox(
                width: 40,
                child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 140,
                child: Text('Nama Barang', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 100,
                child: Text('Tanggal Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 60,
                child: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              numeric: true,
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Text('Lokasi Stok', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 60,
                child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          rows: widget.salesData.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 40,
                    child: Text('${index + 1}'),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 140,
                    child: Tooltip(
                      message: item['nama_barang'] ?? '',
                      child: Text(
                        item['nama_barang'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      item['kategori'] ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(_formatDate(item['tanggal_keluar'])),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${item['jumlah']}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Tooltip(
                      message: item['lokasi_stok'] ?? '',
                      child: Text(
                        item['lokasi_stok'] ?? '',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 60,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _showDeleteConfirmation(item['id']),
                      tooltip: 'Hapus',
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
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