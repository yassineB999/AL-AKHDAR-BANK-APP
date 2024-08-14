// services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/App/api/Authentifie');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Store data in SharedPreferences
      await prefs.setString('role', data['role']);
      await prefs.setString('token', data['token']);

      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> user) async {
    final url = Uri.parse('$baseUrl/App/api/Inscrire');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    final token = prefs.getString('token');

    if (role != null && token != null) {
      return {'role': role, 'token': token};
    } else {
      throw Exception('No user data found');
    }
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await prefs.remove('token');
  }
}
