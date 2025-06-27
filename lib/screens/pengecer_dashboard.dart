// lib/screens/pengecer_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'login_screen.dart';

class PengecerDashboard extends StatelessWidget {
  final User user;

  const PengecerDashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pengecer'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text(
                            user.name[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang, ${user.name}!',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Role: ${user.role.toUpperCase()}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                user.email,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Order Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Order Pending', '5', Colors.red),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('Total Order Bulan Ini', '23', Colors.green),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Pengecer Menu
            const Text(
              'Menu Pengecer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 15),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    icon: Icons.add_shopping_cart,
                    title: 'Buat Order',
                    color: Colors.orange,
                    onTap: () => _showSnackBar(context, 'Fitur Buat Order'),
                  ),
                  _buildMenuCard(
                    icon: Icons.list_alt,
                    title: 'Daftar Order',
                    color: Colors.blue,
                    onTap: () => _showSnackBar(context, 'Fitur Daftar Order'),
                  ),
                  _buildMenuCard(
                    icon: Icons.inventory_2,
                    title: 'Katalog Produk',
                    color: Colors.green,
                    onTap: () => _showSnackBar(context, 'Fitur Katalog Produk'),
                  ),
                  _buildMenuCard(
                    icon: Icons.payment,
                    title: 'Pembayaran',
                    color: Colors.purple,
                    onTap: () => _showSnackBar(context, 'Fitur Pembayaran'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}