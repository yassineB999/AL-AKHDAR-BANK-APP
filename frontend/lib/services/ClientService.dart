
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:frontend/models/Utilisateur.dart';
import 'package:frontend/models/Reclamation.dart';
import 'package:frontend/models/Offre.dart';

class ClientService {
  static const String baseUrl = 'http://localhost:8080/App/api/client';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Utilisateur?> getProfile() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile. Status code: ${response.statusCode}');
    }
  }

  static Future<Utilisateur?> updateProfile(Utilisateur utilisateur) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/updateProfile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(utilisateur.toJson()),
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile. Status code: ${response.statusCode}');
    }
  }

  static Future<void> sendDemandeCreationCompte() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/SendDemandeCreationCompte'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send demande creation compte. Status code: ${response.statusCode}');
    }
  }

  static Future<void> sendReclamation(Reclamation reclamation) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/SendReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reclamation.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send reclamation. Status code: ${response.statusCode}');
    }
  }

  static Future<List<Reclamation>> listReclamation() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/ListReclamation'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Reclamation.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load reclamations. Status code: ${response.statusCode}');
    }
  }

  static Future<Offre> detailsOffre(int idOffre) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/DetailsOffre/$idOffre'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Offre.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load offer details. Status code: ${response.statusCode}');
    }
  }

  static Future<String> offreName(int idOffre) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/OffreName/$idOffre'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load offer name. Status code: ${response.statusCode}');
    }
  }
  static Future<List<Offre>> getAllOffres() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/allOffres'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Offre.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load offers. Status code: ${response.statusCode}');
    }
  }

}
