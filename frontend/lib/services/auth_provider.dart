import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final ApiService apiService;
  String? _token;
  String? get token => _token;

  AuthProvider({required this.apiService});

  Future<void> login(String email, String password) async {
    try {
      final response = await apiService.login(email, password);
      _token = response['token'];

      // Save token and role in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      await prefs.setString('role', response['role']);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> register(Map<String, dynamic> user) async {
    try {
      await apiService.register(user);
      // Handle post-registration actions if needed
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
  Future<void> signOut() async {
    // Clear token and role from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');

    // Clear the token in the provider
    _token = null;
    notifyListeners();
  }
}
