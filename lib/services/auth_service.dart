// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class AuthService {
  static List<User>? _users;

  // Load users dari JSON file
  static Future<void> loadUsers() async {
    if (_users != null) return;

    try {
      final String response = await rootBundle.loadString('assets/data/users.json');
      final Map<String, dynamic> data = json.decode(response);
      _users = (data['users'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } catch (e) {
      print('Error loading users: $e');
      _users = [];
    }
  }

  // Authenticate user
  static Future<User?> authenticate(String username, String password) async {
    await loadUsers();
    
    try {
      return _users?.firstWhere(
        (user) => user.username == username && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Get all users (untuk debugging)
  static Future<List<User>> getAllUsers() async {
    await loadUsers();
    return _users ?? [];
  }
}