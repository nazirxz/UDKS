// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/admin_data_service.dart';
import '../utils/dashboard_utils.dart';
import '../widgets/admin_sales_page_widget.dart';
import '../widgets/admin_purchase_page_widget.dart';
import '../widgets/admin_return_page_widget.dart';

class AdminDashboard extends StatefulWidget {
  final User user;

  const AdminDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  Map<String, dynamic> dashboardStats = {};
  List<Map<String, dynamic>> weeklyData = [];
  List<Map<String, dynamic>> recentTransactions = [];
  List<Map<String, dynamic>> inventoryAlerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Menggunakan data yang sama dengan manager dashboard
      final stats = {
        'barang_masuk_hari_ini': 45,
        'barang_keluar_hari_ini': 32,
        'transaksi_penjualan_hari_ini': 18,
        'transaksi_pembelian_hari_ini': 8
      };
      final weekly = [
        {'day_short': 'Sen', 'barang_masuk': 45, 'barang_keluar': 32},
        {'day_short': 'Sel', 'barang_masuk': 62, 'barang_keluar': 48},
        {'day_short': 'Rab', 'barang_masuk': 38, 'barang_keluar': 29},
        {'day_short': 'Kam', 'barang_masuk': 75, 'barang_keluar': 56},
        {'day_short': 'Jum', 'barang_masuk': 89, 'barang_keluar': 67},
        {'day_short': 'Sab', 'barang_masuk': 56, 'barang_keluar': 41},
        {'day_short': 'Min', 'barang_masuk': 42, 'barang_keluar': 31}
      ];
      final transactions = [
        {
          'type': 'penjualan',
          'customer': 'PT. Maju Jaya',
          'items': 15,
          'amount': 2500000
        },
        {
          'type': 'pembelian',
          'supplier': 'CV. Sumber Rejeki',
          'items': 8,
          'amount': 1200000
        },
        {
          'type': 'penjualan',
          'customer': 'Toko Berkah',
          'items': 22,
          'amount': 3200000
        }
      ];
      final alerts = [
        {
          'product_name': 'Minyak Goreng Tropical 2L',
          'current_stock': 5,
          'minimum_stock': 20,
          'status': 'critical'
        },
        {
          'product_name': 'Beras Premium 5kg',
          'current_stock': 15,
          'minimum_stock': 30,
          'status': 'low'
        }
      ];

      setState(() {
        dashboardStats = stats;
        weeklyData = weekly;
        recentTransactions = transactions;
        inventoryAlerts = alerts;
        isLoading = false;
      });
    } catch (e) {
      // Handle error silently for demo
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          DashboardUtils.buildUserInfoBadge(widget.user),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => DashboardUtils.showSnackBar(context, 'Notifikasi'),
          ),
          DashboardUtils.buildPopupMenu(
            context, 
            widget.user, 
            (value) => DashboardUtils.handleMenuSelection(context, value, widget.user),
          ),
        ],
      ),
      body: isLoading ? _buildLoadingWidget() : _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Penjualan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Pembelian',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_return),
          label: 'Return',
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBerandaPage();
      case 1:
        return const AdminSalesPageWidget();
      case 2:
        return const AdminPurchasePageWidget();
      case 3:
        return const AdminReturnPageWidget();
      default:
        return _buildBerandaPage();
    }
  }

  Widget _buildBerandaPage() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            
            // Statistics Cards
            _buildStatisticsCards(),
            const SizedBox(height: 20),
            
            // Weekly Chart
            _buildWeeklyChart(),
            const SizedBox(height: 20),
            
            // Recent Transactions
            _buildRecentTransactions(),
            const SizedBox(height: 20),
            
            // Inventory Alerts
            _buildInventoryAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(
                widget.user.name[0],
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang, ${widget.user.name}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Role: ${widget.user.role.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistik Hari Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Barang Masuk',
                '${dashboardStats['barang_masuk_hari_ini'] ?? 0}',
                Icons.arrow_downward,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Barang Keluar',
                '${dashboardStats['barang_keluar_hari_ini'] ?? 0}',
                Icons.arrow_upward,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Transaksi Penjualan',
                '${dashboardStats['transaksi_penjualan_hari_ini'] ?? 0}',
                Icons.shopping_cart,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Transaksi Pembelian',
                '${dashboardStats['transaksi_pembelian_hari_ini'] ?? 0}',
                Icons.shopping_bag,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 28),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Barang Masuk/Keluar Mingguan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: _buildSimpleBarChart(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Barang Masuk', Colors.green),
                const SizedBox(width: 20),
                _buildLegendItem('Barang Keluar', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleBarChart() {
    if (weeklyData.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: weeklyData.map((data) {
          final masuk = (data['barang_masuk'] ?? 0).toDouble();
          final keluar = (data['barang_keluar'] ?? 0).toDouble();
          final maxValue = 160.0; // Max untuk scaling

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Bar untuk barang masuk
                    Container(
                      width: 12,
                      height: (masuk / maxValue) * 140,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Bar untuk barang keluar
                    Container(
                      width: 12,
                      height: (keluar / maxValue) * 140,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  data['day_short'] ?? '',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () => DashboardUtils.showSnackBar(context, 'Lihat Semua Transaksi'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...recentTransactions.take(3).map((transaction) {
              return _buildTransactionItem(transaction);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isJual = transaction['type'] == 'penjualan';
    final color = isJual ? Colors.green : Colors.blue;
    final icon = isJual ? Icons.arrow_upward : Icons.arrow_downward;
    final partner = isJual ? transaction['customer'] : transaction['supplier'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${transaction['items']} item • ${isJual ? 'Penjualan' : 'Pembelian'}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatCurrency(transaction['amount'] ?? 0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAlerts() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Peringatan Stok',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...inventoryAlerts.map((alert) {
              return _buildAlertItem(alert);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(Map<String, dynamic> alert) {
    final isCritical = alert['status'] == 'critical';
    final color = isCritical ? Colors.red : Colors.orange;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isCritical ? Icons.error : Icons.warning,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['product_name'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Stok: ${alert['current_stock']} (Min: ${alert['minimum_stock']})',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isCritical ? 'KRITIS' : 'RENDAH',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}