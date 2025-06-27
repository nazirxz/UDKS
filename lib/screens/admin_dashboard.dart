// lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/dashboard_utils.dart';

class AdminDashboard extends StatelessWidget {
  final User user;

  const AdminDashboard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.red,
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
            DashboardUtils.buildWelcomeCard(user, Colors.red),
            
            const SizedBox(height: 20),
            
            // Admin Menu
            const Text(
              'Menu Admin',
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
                    icon: Icons.people,
                    title: 'Kelola User',
                    color: Colors.blue,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Kelola User'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.inventory,
                    title: 'Kelola Produk',
                    color: Colors.green,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Kelola Produk'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Laporan',
                    color: Colors.orange,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Laporan'),
                  ),
                  DashboardUtils.buildMenuCard(
                    context,
                    icon: Icons.settings,
                    title: 'Pengaturan',
                    color: Colors.purple,
                    onTap: () => DashboardUtils.showSnackBar(context, 'Fitur Pengaturan'),
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