// lib/screens/pengecer_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';

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
            DashboardUtils.buildWelcomeCard(user, Colors.orange),
            
            const SizedBox(height: 20),
            
            // Order Statistics
            Row(
              children: [
                Expanded(
                  child: DashboardUtils.buildStatCard('Order Pending', '5', Colors.red),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DashboardUtils.buildStatCard('Total Order Bulan Ini', '23', Colors.green),
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
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.add_shopping_cart,
                    title: 'Buat Order',
                    color: Colors.orange,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Buat Order'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.list_alt,
                    title: 'Daftar Order',
                    color: Colors.blue,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Daftar Order'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.inventory_2,
                    title: 'Katalog Produk',
                    color: Colors.green,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Katalog Produk'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.payment,
                    title: 'Pembayaran',
                    color: Colors.purple,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Pembayaran'),
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