// lib/screens/manager_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ManagerDashboard extends StatelessWidget {
  final User user;

  const ManagerDashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Manager'),
        backgroundColor: Colors.purple,
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
                          backgroundColor: Colors.purple,
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
            
            // Manager Statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Revenue Bulan Ini', 'Rp 125.5M', Colors.green),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard('Team Performance', '88%', Colors.blue),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Manager Menu
            const Text(
              'Menu Manager',
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
                    icon: Icons.dashboard,
                    title: 'Dashboard Analytics',
                    color: Colors.purple,
                    onTap: () => _showSnackBar(context, 'Fitur Dashboard Analytics'),
                  ),
                  _buildMenuCard(
                    icon: Icons.group,
                    title: 'Kelola Tim',
                    color: Colors.blue,
                    onTap: () => _showSnackBar(context, 'Fitur Kelola Tim'),
                  ),
                  _buildMenuCard(
                    icon: Icons.assessment,
                    title: 'Laporan Performa',
                    color: Colors.green,
                    onTap: () => _showSnackBar(context, 'Fitur Laporan Performa'),
                  ),
                  _buildMenuCard(
                    icon: Icons.approval,
                    title: 'Approval Order',
                    color: Colors.orange,
                    onTap: () => _showSnackBar(context, 'Fitur Approval Order'),
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