// lib/screens/sales_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';

class SalesDashboard extends StatelessWidget {
  final User user;

  const SalesDashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Sales'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          DashboardUtils.buildUserInfoBadge(user),
          DashboardUtils.buildPopupMenu(
            context, 
            user, 
            (value) => DashboardUtils.handleMenuSelection(context, value, user),
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
            DashboardUtils.buildWelcomeCard(user, Colors.green),
            
            const SizedBox(height: 20),
            
            // Sales Statistics
            Row(
              children: [
                Expanded(
                  child: DashboardUtils.buildStatCard('Penjualan Hari Ini', 'Rp 2.500.000', Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DashboardUtils.buildStatCard('Target Bulan Ini', '75%', Colors.orange),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Sales Menu
            const Text(
              'Menu Sales',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 15),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.shopping_cart,
                    title: 'Input Penjualan',
                    color: Colors.green,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Input Penjualan'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.people,
                    title: 'Data Customer',
                    color: Colors.blue,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Data Customer'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.history,
                    title: 'Riwayat Penjualan',
                    color: Colors.orange,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Riwayat Penjualan'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.trending_up,
                    title: 'Target Sales',
                    color: Colors.purple,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Target Sales'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}